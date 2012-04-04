module ReadlineNG
  class Color
    BOLD = { :off => 1, :on => 22 }
  end

  # Subclasses

  class Black < Color
    FOREGROUND = 30
    BACKGROUND = 40
  end

  class Red < Color
    FOREGROUND = 31
    BACKGROUND = 41
  end

  class Green < Color
    FOREGROUND = 32
    BACKGROUND = 42
  end

  class Yellow < Color
    FOREGROUND = 33
    BACKGROUND = 43
  end

  class Blue < Color
    FOREGROUND = 34
    BACKGROUND = 44
  end

  class Magenta < Color
    FOREGROUND = 35
    BACKGROUND = 45
  end

  class Cyan < Color
    FOREGROUND = 36
    BACKGROUND = 46
  end

  class White < Color
    FOREGROUND = 37
    BACKGROUND = 47
  end

  class Default < Color
    FOREGROUND = 39
    BACKGROUND = 49
  end
end
