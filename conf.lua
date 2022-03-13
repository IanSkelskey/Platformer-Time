debug_active = true

function love.conf(t)
	if debug_active then
		t.console = true
	else
		t.console = false
	end
end
