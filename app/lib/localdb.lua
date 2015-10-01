-- Sample code is licensed under the MIT License, the same license that Lua is licensed under:
-- Copyright © 2011-2015 Kwiksher LLP.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
------------------------------------------------------------
------------------------------------------------------------
local _M = {}
local sqlite3 = require "sqlite3"
---------------------
---------------------
local destDir = system.DocumentsDirectory  -- where the file is stored
-- Methods public
function _M.init(name)
	_M.name = name..".db"
	local path = system.pathForFile(_M.name , destDir )
	_M.db = sqlite3.open( path );
end

function _M.cleanup()
	local results, reason = os.remove( system.pathForFile(_M.name, destDir  ) )
	if results then
	   print( "file removed" )
	else
	   print( "file does not exist", reason )
	end
end

function _M.close()
	if _M.db:isopen() then
		_M.db:close()
	end
end

function _M.setup(tablename, fields)
	local tablesetup = ""
	tablesetup = "CREATE TABLE IF NOT EXISTS "..tablename..
					"(id INTEGER PRIMARY KEY, "..fields.." );"
	_M.db:exec( tablesetup )
end

function _M.create(tablename, params)
	local sql = "INSERT INTO "..tablename.."  VALUES (NULL,"..params.. ");"
  if (sql ~= nil) then
  	-- print(sql)
  	_M.db:exec( sql )
  	-- print(" >[SQLite] SUCCESS EXECUTE...")
  	return _M.db:last_insert_rowid()
  end
end

function _M.read(tablename, params)
	local sql = "SELECT * FROM "..tablename.." WHERE "..params..";"
	-- print(sql)
  local ret = {}
	for row in _M.db:nrows( sql ) do
		table.insert(ret, row)
	end
  return ret
end

function _M.update(tablename,params, id)
	local sql = "UPDATE "..tablename.." SET "..params.." WHERE id="..id..";"
	print(sql)
	return _M.db:exec( sql )
end

function _M.delete(tablename, id)
	local sql = "DELETE FROM "..tablename.. " WHERE id="..id..";"
	_M.db:exec( sql )
end
print("------ lib.localdb ----")
--
return _M