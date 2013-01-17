api.cfm
=======

An elegant, lightweight, almost-zero-install ColdFusion REST API.
-----------------------------------------------------------------

By default it looks for CFCs in /service.  Change this in line 20 if desired.

Default URL pattern is:
  {host}/api.cfm/cfc/method/[arg1]/[arg2]/...

So, an actual URL would look like this:
  http://localhost/api.cfm/user/login/username/password


Caveats:
* You've got 'api.cfm' in your URL
* Doesn't support named arguments
