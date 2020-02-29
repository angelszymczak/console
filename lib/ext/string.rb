class String
  def error
    reverse_color.red
  end

  def success
    reverse_color.green
  end

  def ask
    reverse_color.blue
  end

  def important
    reverse_color.brown.blink
  end

  def red
    "\e[31m#{self}\e[0m"
  end

  def green
    "\e[32m#{self}\e[0m"
  end

  def brown
    "\e[33m#{self}\e[0m"
  end

  def blue
    "\e[34m#{self}\e[0m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end

  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end
