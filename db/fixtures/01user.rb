User.seed(
  { name:  '個人ユーザー', email: 'dx.proto.kojin@gmail.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'cyan'},
  { name:  '法人ユーザー', email: 'dx.proto.hojin@gmail.com', password: "password01", role: 1, company_name: '株式会社テスト法人', confirmed_at: Time.zone.now,color: 'cyan'},
  { name:  '管理ユーザー', email: 'admin@sample', password: "password01", role: 9, company_name: '', confirmed_at: Time.zone.now, color: 'cyan'},
  #法人
  { name:  '戸澤総研', email: 'tozawasoken@pca.com', password: "password01", role: 1, company_name: '戸澤総研', confirmed_at: Time.zone.now, color: 'crimson'},
  { name:  'KANEKOトイズファクトリー', email: 'kanekotoys@pca.com', password: "password01", role: 1, company_name: 'KANEKOトイズファクトリー', confirmed_at: Time.zone.now, color: 'yellow'},
  { name:  '澤田商店', email: 'sawadashoten@pca.com', password: "password01", role: 1, company_name: '澤田商店', confirmed_at: Time.zone.now, color: 'green'},
  #ここから個人
  { name:  '佐藤翔太', email: 'satoshota@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '鈴木健太', email: 'suzukikenta@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '高橋美咲', email: 'takahashimisaki@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '田中蓮', email: 'tanakaren@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '伊藤葵', email: 'itoaoi@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '山本大輝', email: 'yamamotodaiki@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
  { name:  '中村さくら', email: 'nakamurasakura@pca.com', password: "password01", role: 0, confirmed_at: Time.zone.now, color: 'blue'},
)
