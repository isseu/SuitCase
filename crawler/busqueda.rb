
class Busqueda

  def searchUser(lista, pagina)

    puts "\t [+] Buscando por Rut"
    lista.each_with_index do |user, number|
      # Por RUT
      if ['Civil', 'Laboral'].include? pagina.class.name.to_s
        if user.rut != nil
          puts "\t \t " + number.to_s + ") " + user.rut.to_s
          begin
            pagina.Search('', nil, user.rut, '', '', '', 2, "tdTres", false)
          rescue Exception => e
            puts "[!] Error al intentar: " + e.to_s
          end
        end
      end
    end

    puts "\t [+] Buscando por Posibles Nombres"
    lista.each_with_index do |user, number|

      puts "\t \t [+] " + user.name.to_s + " "+ user.first_lastname + " (" + user.rut.to_s + ")"

      #Nombres Posibles
      listaNombres = user.possible_names
      listaNombres.each_with_index do |lista, j|
        puts "\t \t \t " + j.to_s + ") Nombre: " + lista.name.to_s + " Apellidos: " + lista.first_lastname + " " + lista.second_lastname.to_s

        begin
          if ['Corte', 'Suprema'].include? pagina.class.name.to_s
            pagina.Search('', nil, '', lista.name.to_s, lista.first_lastname, lista.second_lastname.to_s, 3, "tdNombre", false)
          elsif ['Civil', 'Laboral'].include? pagina.class.name.to_s
            pagina.Search('', nil, '', lista.name.to_s, lista.first_lastname, lista.second_lastname.to_s, 3, "tdCuatro", false)
          end
        rescue Exception => e
          puts "[!] Error al intentar: " + e.to_s
        end
      end
    end
  end

  def do_search(search_id)
    s = Search.find(search_id)

    # Marcar resultado como listo
    s.set_ready
  end

  def searchClient(lista, pagina)
    puts "\t [+] Buscando por Clientes"
    lista.each_with_index do |client, number|

      puts "\t \t [+] " + client.name.to_s + " "+ client.first_lastname + " (" + client.rut.to_s + ")"
      # Por RUT
      if ['Civil', 'Laboral'].include? pagina.class.name.to_s
        if client.rut != nil
          puts "\t \t \t 1.- Rut: " + client.rut.to_s

          begin
            pagina.Search('', nil, client.rut, '', '', '', 2, "tdTres", false)
          rescue Exception => e
            puts "[!] Error al intentar: " + e.to_s
          end

        end
      end

      #Nombre y Apellido Paterno
      begin
        puts "\t \t \t 2.- Nombre: " + client.name.to_s + " Apellido Paterno: " + client.first_lastname
        if ['Corte', 'Suprema'].include? pagina.class.name.to_s
          pagina.Search('', nil, '', client.name.to_s, client.first_lastname,'', 3, "tdNombre", false)
        elsif ['Civil', 'Laboral'].include? pagina.class.name.to_s
          pagina.Search('', nil, '', client.name.to_s, client.first_lastname,'', 3, "tdCuatro", false)
        end
      rescue Exception => e
        puts "[!] Error al intentar: " + e.to_s
      end

      #Nombre y Apellido Materno
      begin
        puts "\t \t \t 3.- Nombre: " + client.name.to_s + " Apellido Materno: " + client.second_lastname
        if ['Corte', 'Suprema'].include? pagina.class.name.to_s
          pagina.Search('', nil, '', client.name.to_s,'', client.second_lastname.to_s, 3, "tdNombre", false)
        elsif ['Civil', 'Laboral'].include? pagina.class.name.to_s
          pagina.Search('', nil, '', client.name.to_s,'', client.second_lastname.to_s, 3, "tdCuatro", false)
        end
      rescue Exception => e
        puts "[!] Error al intentar: " + e.to_s
      end

      #Apellido Paterno y Materno
      begin
        puts "\t \t \t 4.- Apellidos: " + client.first_lastname.to_s + " " + client.second_lastname
        if ['Corte', 'Suprema'].include? pagina.class.name.to_s
          pagina.Search('', nil, '','', client.first_lastname, client.second_lastname.to_s, 3, "tdNombre", false)
        elsif ['Civil', 'Laboral'].include? pagina.class.name.to_s
          pagina.Search('', nil, '','', client.first_lastname, client.second_lastname.to_s, 3, "tdCuatro", false)
        end
      rescue Exception => e
        puts "[!] Error al intentar: " + e.to_s
      end

    end
  end

  def searchTracking(lista, pagina)

    puts "\t [+] Trackeando Casos por Usuarios"

    lista.each_with_index do |user, i|
      puts "\t \t [+] " + user.name.to_s + " "+ user.first_lastname + " (" + user.rut.to_s + ")"
      user.case_records.each_with_index do |case_record, j|
        caso = Case.find(case_record.case_id)
        if caso != nil
          if (caso.info_type == 'InfoCorte' && (['Corte'].include? pagina.class.name.to_s)) || (caso.info_type == 'InfoSuprema'&& (['Suprema'].include? pagina.class.name.to_s))
            puts "\t \t \t " + j.to_s + ") Caso: " + caso.rol.to_s
            pagina.Search(caso.rol, user, '', user.name.to_s, user.first_lastname.to_s, user.second_lastname.to_s, 1, 'tdRecurso', true)
          elsif (caso.info_type == 'InfoLaboral' && (['Laboral'].include? pagina.class.name.to_s)) || (caso.info_type == 'InfoCivil' && (['Civil'].include? pagina.class.name.to_s))
            puts "\t \t \t " + j.to_s + ") Caso: " + caso.rol.to_s
            pagina.Search(caso.rol, user, '', user.name.to_s, user.first_lastname.to_s, user.second_lastname.to_s, 1, 'tdUno', true)
          end
        end

      end
    end
  end
end
