function auto_connect()
	awful.spawn.easy_async_with_shell(
		"ss -tupn | grep kdeconnectd | awk '{print $6}' | sed 's/.*\\[::ffff://;s/\\]:1716//' | head -n1",
		function(stdout)
			local phone_ip = stdout:gsub("%s+", "")
			awful.spawn("adb connect " .. phone_ip, false)
		end
	)
end
