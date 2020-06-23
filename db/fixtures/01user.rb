User.seed(
  { name:  '個人ユーザー', email: 'dx.proto.kojin@gmail.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'cyan'},
  { name:  '法人ユーザー', email: 'dx.proto.hojin@gmail.com', password: "password01", role: 1, company_name: '株式会社テスト法人', confirmed_at: Time.zone.now,color: 'cyan'},
  { name:  '管理ユーザー', email: 'admin@sample', password: "password01", role: 9, company_name: '', confirmed_at: Time.zone.now, color: 'cyan'}

)
