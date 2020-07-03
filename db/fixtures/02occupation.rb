tozawa = User.find_by(email: 'tozawasoken@pca.com')
kaneko = User.find_by(email: 'kanekotoys@pca.com')
sawada = User.find_by(email: 'sawadashoten@pca.com')

Occupation.seed(
  #戸澤総研
  {user: tozawa, name: 'ITコンサルタント', color: 'red'},
  {user: tozawa, name: 'PM', color: 'hotpink'},
  {user: tozawa, name: 'sales manager', color: 'salmon'},
  #KANEKOトイズファクトリー
  {user: kaneko, name: 'インフラエンジニア', color: 'orange'},
  {user: kaneko, name: '生産管理', color: 'khaki'},
  {user: kaneko, name: '営業アシスタント', color: 'lemonchiffon'},
  #澤田商店
  {user: sawada, name: 'インサイドセールス', color: 'mediumaquamarine'},
  {user: sawada, name: '経理', color: 'aquamarine'},
  {user: sawada, name: '社内SE', color: 'lime'},

)
