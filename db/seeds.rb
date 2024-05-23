# db/seeds.rb

# Create an admin user
admin = User.new(
  email: 'admin@example.com',
  username: 'admin', # Set a username for the admin user
  password: 'password', # Set a secure password here
  password_confirmation: 'password', # Ensure password confirmation matches
  role: :admin # Set the role to admin
)

# Save the admin user
if admin.save
  puts 'Admin user created successfully.'
else
  puts 'Error creating admin user:', admin.errors.full_messages.join(', ')
end
