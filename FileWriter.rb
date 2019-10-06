require 'csv'

def saveDataToFile(data)
  CSV.open("Hello.csv", "wb") do |csv_line|
    csv_line << ['Название', 'Цена', 'Изображение']
    data.each do |current_line|
      csv_line << current_line
    end
   end
end
