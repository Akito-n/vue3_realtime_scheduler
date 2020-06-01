[:individual, :company, :admin].each.with_index do |role, i|
  user = User.new(
    name: Gimei.name,
    email: "#{i}@example.com",
    password: 'test1234',
    role: role,
  )
  user.skip_confirmation!
  user.save!
end
