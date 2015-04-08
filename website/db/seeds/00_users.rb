puts '[+] Creando usuarios'

User.create!(email: 'ejcorrea@uc.cl',
                name: 'Enrique',
                lastnames: 'Correa Velasco',
                rut: '18394729-k',
                password: 'mamamia123',
                password_confirmation: 'mamamia123',
                role: :admin)
