puts '[+] Creando usuarios'

User.create!(email: 'ejcorrea@uc.cl',
                name: 'Enrique',
                first_lastname: 'Correa',
                second_lastname: 'Velasco',
                rut: '18394729-k',
                password: 'mamamia123',
                password_confirmation: 'mamamia123',
                role: :admin)

User.create!(email: 'bochagavia@uc.cl',
             name: 'Baltazar',
             first_lastname: 'Ochagavia',
             second_lastname: 'Balbontin',
             rut: '18395565-9',
             password: 'mamamia123',
             password_confirmation: 'mamamia123',
             role: :admin)