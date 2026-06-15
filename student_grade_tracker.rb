# ============================================================
#   Student Grade Tracker
#   A CLI app to record scores, calculate averages,
#   assign letter grades, and export a report to .txt
# ============================================================

# ---------- Helper Methods ----------

def letter_grade(score)
  case score
  when 90..100 then "A"
  when 80..89  then "B"
  when 70..79  then "C"
  when 60..69  then "D"
  else              "F"
  end
end

def grade_remark(grade)
  case grade
  when "A" then "Excellent"
  when "B" then "Good"
  when "C" then "Average"
  when "D" then "Below Average"
  else          "Failing"
  end
end

def divider(char = "=", length = 45)
  puts char * length
end

def valid_score?(input)
  input.match?(/^\d+(\.\d+)?$/) && input.to_f.between?(0, 100)
end

# ---------- Data Collection ----------

students = []

divider
puts "       STUDENT GRADE TRACKER"
divider
print "How many students do you want to enter? "
num = gets.chomp.to_i

if num <= 0
  puts "No students entered. Exiting."
  exit
end

num.times do |i|
  puts "\n--- Student #{i + 1} ---"

  print "Enter name  : "
  name = gets.chomp.capitalize
  name = "Student #{i + 1}" if name.empty?

  score = nil
  loop do
    print "Enter score (0-100): "
    input = gets.chomp
    if valid_score?(input)
      score = input.to_f
      break
    else
      puts "  Invalid score. Please enter a number between 0 and 100."
    end
  end

  grade = letter_grade(score)
  students << { name: name, score: score, grade: grade }
end

# ---------- Calculations ----------

scores      = students.map { |s| s[:score] }
average     = scores.sum / scores.size.to_f
top         = students.max_by { |s| s[:score] }
bottom      = students.min_by { |s| s[:score] }
pass_count  = students.count { |s| s[:score] >= 60 }
fail_count  = students.size - pass_count

# ---------- Terminal Output ----------

puts "\n"
divider
puts "           GRADE REPORT"
divider
puts "#{"NAME".ljust(18)} #{"SCORE".rjust(6)}   #{"GRADE".ljust(5)}  REMARK"
divider("-")

students.each do |s|
  puts "#{s[:name].ljust(18)} #{s[:score].to_s.rjust(6)}   #{s[:grade].ljust(5)}  #{grade_remark(s[:grade])}"
end

divider("-")
puts "Class Average   : #{average.round(2)}"
puts "Top Scorer      : #{top[:name]} (#{top[:score]})"
puts "Lowest Scorer   : #{bottom[:name]} (#{bottom[:score]})"
puts "Passed (≥60)    : #{pass_count} student(s)"
puts "Failed (<60)    : #{fail_count} student(s)"
divider

# ---------- File Export ----------

report_path = "grades_report.txt"

File.open(report_path, "w") do |f|
  f.puts "=" * 45
  f.puts "           GRADE REPORT"
  f.puts "=" * 45
  f.puts "#{"NAME".ljust(18)} #{"SCORE".rjust(6)}   #{"GRADE".ljust(5)}  REMARK"
  f.puts "-" * 45

  students.each do |s|
    f.puts "#{s[:name].ljust(18)} #{s[:score].to_s.rjust(6)}   #{s[:grade].ljust(5)}  #{grade_remark(s[:grade])}"
  end

  f.puts "-" * 45
  f.puts "Class Average   : #{average.round(2)}"
  f.puts "Top Scorer      : #{top[:name]} (#{top[:score]})"
  f.puts "Lowest Scorer   : #{bottom[:name]} (#{bottom[:score]})"
  f.puts "Passed (>=60)   : #{pass_count} student(s)"
  f.puts "Failed (<60)    : #{fail_count} student(s)"
  f.puts "=" * 45
  f.puts "Report generated: #{Time.now.strftime("%d %b %Y, %I:%M %p")}"
end

puts "\nReport saved to '#{report_path}' successfully!"
