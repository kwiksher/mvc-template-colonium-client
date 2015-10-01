# mvc-template-coronium-client

## setup
```
bower install
npm install
grunt
```

## main.lua
please set IP address and key of your coronium server

```
_G.appId  = "192.168.56.101"
_G.apiKey = "2d0aa65e-208e-4e70-993c-e36a34bac6aa"
```

## Prerequisites
### setup coronium server
* ubuntu http://coronium.io/coronium-on-ubuntu.html
* amazon http://coronium.io/coronium-on-amazon.html

## ubuntu Server 14.04.3 on virtual box
* install with openSSH
* create account as ubuntu
* sudo ifconfig eth1 192.168.56.101 netmask 255.255.255.0 up
* append eth1 to /etc/network/interfaces
```
auto eth1
iface eth1 inet static
address 192.168.56.101
netmask 255.255.255.0
network 192.168.56.0
broadcast 192.168.56.255
```
### virtual box
* virtual box > preference >Network > HostOnlyAdapter > add
```
	192.168.56.1
	255.255.255.0
	DHCP Server Off
```

* virtual box > Ubuntue > Network > HostAdapter 2

# MVC
* testcase/unittest.lua
```
local _M =
{
    {name="user add", desc = "",
	    evt = {name = "mod_user", API="addUser", page="view.page.mod_user"}},
}
```
addUser is defined in controller/mod_user.lua

* view/page/testcases.lua shows the list of unittest.lua and onRowTouch() to dispath the following event
```
            _G.Router:dispatchEvent({name = row.id.evt.name}, row.id.evt.API, row.id.evt.page)
```
1. controller/mod_user.lua receives the event
1. model/user.lua create user model
1. addUser to request coronium:registerUser

```
_M.addUser = function(page)
  local user = userModel.create("test1@kwiksher.com", "12345678", "yamamoto", "naoya")
	coronium:registerUser( user, function(ret)
		table.print(ret)
		  composer.gotoScene(page, {params =	{ API = "addUser", model = user, result = ret.result, error = ret.error}})
	end)
end

```

