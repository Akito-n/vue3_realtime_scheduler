tozawa = User.find_by(email: 'tozawasoken@pca.com')
kaneko = User.find_by(email: 'kanekotoys@pca.com')
sawada = User.find_by(email: 'sawadashoten@pca.com')

sato = User.find_by(email: 'satoshota@pca.com')
suzuki = User.find_by(email: 'suzukikenta@pca.com')
takahashi = User.find_by(email: 'takahashimisaki@pca.com')
tanaka = User.find_by(email: 'takahashimisaki@pca.com')
ito = User.find_by(email: 'itoaoi@pca.com')
yamamoto = User.find_by(email: 'yamamotodaiki@pca.com')
nakamura = User.find_by(email: 'nakamurasakura@pca.com')

# occupations
it = Occupation.find_by(name: 'ITコンサルタント')
pm = Occupation.find_by(name: 'PM')
sales = Occupation.find_by(name: 'sales manager')
infra = Occupation.find_by(name: 'インフラエンジニア')
seisan = Occupation.find_by(name: '生産管理')
eigyo = Occupation.find_by(name: '営業アシスタント')
inside = Occupation.find_by(name: 'インサイドセールス')
keiri = Occupation.find_by(name: '経理')
se = Occupation.find_by(name: '社内SE')


Recruitement.seed(
  {company_user: tozawa, individual_user: sato, occupation: it },
  {company_user: tozawa, individual_user: sato, occupation: pm },
  {company_user: sawada, individual_user: sato, occupation: se },
  {company_user: tozawa, individual_user: suzuki, occupation: pm },
  {company_user: kaneko, individual_user: suzuki, occupation: infra },
  {company_user: sawada, individual_user: suzuki, occupation: se },
  {company_user: tozawa, individual_user: takahashi, occupation: sales },
  {company_user: kaneko, individual_user: takahashi, occupation: eigyo},
  {company_user: sawada, individual_user: takahashi, occupation: inside},
  {company_user: kaneko, individual_user: tanaka, occupation: seisan},
  {company_user: sawada, individual_user: tanaka, occupation: keiri},
  {company_user: kaneko, individual_user: ito, occupation: keiri},
  {company_user: kaneko, individual_user: ito, occupation: sales},
  {company_user: sawada, individual_user: ito, occupation: eigyo},
  {company_user: kaneko, individual_user: yamamoto, occupation: eigyo},
  {company_user: sawada, individual_user: yamamoto, occupation: inside},
  {company_user: sawada, individual_user: yamamoto, occupation: keiri},
  {company_user: tozawa, individual_user: nakamura, occupation: sales},
  {company_user: sawada, individual_user: nakamura, occupation: inside},
)
