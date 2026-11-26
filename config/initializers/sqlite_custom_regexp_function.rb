# frozen_string_literal: true

# Adds a REGEXP function to SQLite connections (development and test).
module SqliteRegexpFunction
  def configure_connection
    super
    @raw_connection.create_function("regexp", 2) do |fn, pattern, expr|
      regex_matcher = Regexp.new(pattern.to_s, Regexp::IGNORECASE)
      fn.result = expr.to_s.match(regex_matcher) ? 1 : 0
    end
  end
end

ActiveSupport.on_load(:active_record_sqlite3adapter) { prepend SqliteRegexpFunction }
