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

User.create!(email: 'caguirre@uc.cl',
             name: 'Carlos',
             first_lastname: 'Aguirre',
             second_lastname: '',
             rut: '18395565-9',
             password: 'mamamia123',
             password_confirmation: 'mamamia123',
             role: :admin)

User.create!(email: 'jjalvear@bam.cl',
             name: 'Jerónimo',
             first_lastname: 'Alvear',
             second_lastname: 'Castillo',
             rut: '10696737-7',
             password: 'mamamia123',
             password_confirmation: 'mamamia123',
             role: :admin)