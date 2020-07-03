tozawa = User.find_by(email: 'tozawasoken@pca.com')
kaneko = User.find_by(email: 'kanekotoys@pca.com')
sawada = User.find_by(email: 'sawadashoten@pca.com')

Occupation.seed(
  #戸澤総研
  {user: tozawa, name: 'ITコンサルタント', color: 'red'},
  {user: tozawa, name: 'PM', color: 'pink'},
  {user: tozawa, name: 'sales manager', color: 'purple'},
  #KANEKOトイズファクトリー
  {user: kaneko, name: 'インフラエンジニア', color: 'orange'},
  {user: kaneko, name: '生産管理', color: 'gray'},
  {user: kaneko, name: '営業アシスタント', color: 'yellow'},
  #澤田商店
  {user: sawada, name: 'インサイドセールス', color: 'green'},
  {user: sawada, name: '経理', color: 'teal'},
  {user: sawada, name: '社内SE', color: 'indigo'},

)
