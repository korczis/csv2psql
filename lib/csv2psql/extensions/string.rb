# encoding: UTF-8

# String class
class String
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map { |e| e.capitalize }.join
  end

  def camel_case_lower
    split('_').reduce([]) { |a, e| a.push(a.empty? ? e : e.capitalize) }.join
  end
end
