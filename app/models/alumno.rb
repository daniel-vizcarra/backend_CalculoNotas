class Alumno < ApplicationRecord
    has_many :notas , class_name: 'Nota'
    def self.calculate_progress_grades(progreso1_dates, progreso2_dates, progreso3_dates)

      if progreso1_dates[:end] >= progreso2_dates[:start] || progreso2_dates[:end] >= progreso3_dates[:start]
        return { error: 'Fechas de los progreso no están en la correcta secuencia.' }
      end

      grades = Alumno.all.map do |alumno|
        notas_count_progreso1 = alumno.notas.where(fecha: progreso1_dates[:start]..progreso1_dates[:end]).count
        notas_count_progreso2 = alumno.notas.where(fecha: progreso2_dates[:start]..progreso2_dates[:end]).count
        notas_count_progreso3 = alumno.notas.where(fecha: progreso3_dates[:start]..progreso3_dates[:end]).count
  
        progreso1_grade = notas_count_progreso1 > 0 ? calculate_grade_for_progreso(alumno, progreso1_dates, notas_count_progreso1, 0.25) : 0
        progreso2_grade = notas_count_progreso2 > 0 ? calculate_grade_for_progreso(alumno, progreso2_dates, notas_count_progreso2, 0.35) : 0
        progreso3_grade = 6 - (progreso1_grade + progreso2_grade)
  
        { alumno_id: alumno.id, nombre: alumno.nombre, progreso1_grade: progreso1_grade, progreso2_grade: progreso2_grade, progreso3_grade: progreso3_grade }
      end
  
      { data: grades }
    end

    private

    def self.calculate_grade_for_progreso(alumno, dates, notas_count, weight)
        notas = alumno.notas.where(fecha: dates[:start]..dates[:end])
        total_notas = notas.sum(:nota)
        (total_notas / notas_count) * weight
    end

end