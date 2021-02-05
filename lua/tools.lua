function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

function disable_buf_default_keymaps(buf)
  local chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '+', '_', '+', '[', ']', '$', '*', '<CR>'
  }
  for k,v in ipairs(chars) do
    vim.api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end
end

function split(str,delimiter)
  local dLen = string.len(delimiter)
  local newDeli = ''
  for i=1,dLen,1 do
    newDeli = newDeli .. "["..string.sub(delimiter,i,i).."]"
  end
  local locaStart,locaEnd = string.find(str,newDeli)
  local arr = {}
  local n = 1
  while locaStart ~= nil do
    if locaStart>0 then
      arr[n] = string.sub(str,1,locaStart-1)
      n = n + 1
    end
    str = string.sub(str,locaEnd+1,string.len(str))
    locaStart,locaEnd = string.find(str,newDeli)
  end
  if str ~= nil then
    arr[n] = str
  end
  return arr
end

function file_extension(file_name)
  local extension = ''
  local first_char = string.sub(file_name,1,1)
  if(first_char ~= '.') then
    local arr = split(file_name,'.')
    local len = table.getn(arr)
    if len > 1 then
      extension = arr[len]
    end
  end
  return extension
end

return {
  disable_buf_default_keymaps = disable_buf_default_keymaps,
  utf8len = utf8len,
  split = split,
  file_extendsion = file_extendsion
}


