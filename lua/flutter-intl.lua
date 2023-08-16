local M = {}

local function run_shell_script(command, callback)
  local job_id = vim.fn.jobstart(command, {
    on_exit = function(job_id, exit_code)
      if exit_code == 0 then
        callback(true)
      else
        callback(false)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
  })
  return job_id
end

local function extract_localizely_token()
  local localizely_token = os.getenv("LOCALIZELY_TOKEN")
  if not localizely_token then
    vim.api.nvim_err_writeln("LOCALIZELY_TOKEN environment variable not set")
    return nil
  end
  return localizely_token
end

-- Function to extract project_id from pubspec.yaml
local function extract_project_id(pubspec_content)
  local project_id = vim.fn.systemlist("grep '^\\s*project_id:' " .. pubspec_content)[1]
  if project_id == nil then
    vim.api.nvim_err_writeln("Localizely project_id not found in pubspec.yaml")
    return nil
  end

  local result = vim.fn.split(project_id, ": ")[2]
  return result

  -- -- code for finding project_id by yaml library
  -- local yaml = require('yaml')
  -- local parsed_yaml = yaml.load(pubspec_content)

  -- if parsed_yaml and parsed_yaml.flutter_intl and parsed_yaml.flutter_intl.localizely then
  --   local project_id = parsed_yaml.flutter_intl.localizely.project_id
  --   return project_id
  -- else
  --   vim.api.nvim_err_writeln("Localizely project_id is missing inside pubspec.yaml")
  --   return nil
  -- end
end

function M.generate()
  run_shell_script('fvm flutter pub run intl_utils:generate', function(success)
    if success then
      print('Intl classes were generated')
    else
      vim.api.nvim_err_writeln("Intl classes generating failed")
      print('')
    end
  end)
end

function M.download_arb()
  local pubspec = vim.fn.getcwd() .. "/pubspec.yaml"
  local project_id = extract_project_id(pubspec)
  local localizely_token = extract_localizely_token()
  if project_id == nil or localizely_token == nil then
    return nil
  end
  local command = "fvm flutter pub run intl_utils:localizely_download --api-token $LOCALIZELY_TOKEN --project-id " ..
      project_id
  run_shell_script(command, function(success)
    if (success) then
      print('ARB files downloaded')
    else
      vim.api.nvim_err_writeln("ARB files cant be downloaded")
    end
  end)
end

function M.upload_arb()
  local pubspec = vim.fn.getcwd() .. "/pubspec.yaml"
  local project_id = extract_project_id(pubspec)
  local localizely_token = extract_localizely_token()
  if project_id == nil or localizely_token == nil then
    return nil
  end
  local command = "fvm flutter pub run intl_utils:localizely_upload_main --api-token $LOCALIZELY_TOKEN --project-id " ..
      project_id
  run_shell_script(command, function(success)
    if (success) then
      print('main ARB file was uploaded')
    else
      vim.api.nvim_err_writeln("main ARB file cant be uploaded")
    end
  end)

end

function M.setup()
  vim.cmd("command! FlutterIntlGenerate lua require'flutter-intl'.generate()")
  vim.cmd("command! FlutterIntlDownload lua require'flutter-intl'.download_arb()")
  vim.cmd("command! FlutterIntlUpload lua require'flutter-intl'.upload_arb()")
end

return M
