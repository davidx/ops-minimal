NAGIOSMAP = {
        'ok' => 0,
        'warning' => 1,
        'critical'  =>2,
        'unknown'  => 3
}

def exit_ok(message)
  exit_generic(:ok, message)
end

def exit_critical(message)
  exit_generic(:critical, message)
end

def exit_warning(message)
  exit_generic(:warning, message)
end

def exit_unknown(message)
  exit_generic(:unknown, message)
end
def exit_generic(status, message)
  print status.to_s.upcase + " " + message   + "\n"
  exit NAGIOSMAP[status.to_s]
end