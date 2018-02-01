admin = User.create!(
  admin: true,
  email: 'admin@test.com',
  password: 'password',
  password_confirmation: 'password',
)
user = User.create!(
  email: 'user@test.com',
  password: 'password',
  password_confirmation: 'password',
)

2.times.each { Post.create(user: admin, text: 'Some text') }
3.times.each { Post.create(user: user, text: 'Some text') }
