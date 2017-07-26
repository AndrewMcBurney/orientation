# frozen_string_literal: true

module DelimiterHelper
  def delimit_string(str)
    "<<<#{str}>>>"
  end

  def match_delimiter_string(str)
    str.match(/<<<(.+?)>>>/)
  end

  def strip_delimiter(str)
    str.gsub(/<<<|>>>/, "")
  end
end
