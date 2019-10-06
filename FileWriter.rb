require 'csv'

def saveDataToFile(data, file_name)
  puts '===== Opening CSV file ====='
  CSV.open(file_name, 'wb') do |csv_line|
    csv_line << ['Название', 'Цена', 'Изображение']
    puts 'Opening successfull'
    puts 'Writing data to file'
    data.each do |current_line|
      csv_line << current_line
    end
  end
  puts 'Written successfully'
end
