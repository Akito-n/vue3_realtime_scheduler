tozawa = User.find_by(email: 'tozawasoken@pca.com')
kaneko = User.find_by(email: 'kanekotoys@pca.com')
sawada = User.find_by(email: 'sawadashoten@pca.com')

sato = User.find_by(email: 'satoshota@pca.com')
suzuki = User.find_by(email: 'suzukikenta@pca.com')
takahashi = User.find_by(email: 'takahashimisaki@pca.com')
nakamura = User.find_by(email: 'nakamurasakura@pca.com')

# occupations
it = Occupation.find_by(name: 'ITコンサルタント')
pm = Occupation.find_by(name: 'PM')
sales = Occupation.find_by(name: 'sales manager')
infra = Occupation.find_by(name: 'インフラエンジニア')
eigyo = Occupation.find_by(name: '営業アシスタント')
inside = Occupation.find_by(name: 'インサイドセールス')
se = Occupation.find_by(name: '社内SE')


Recruitement.seed(:id,
  {id: '00ab8991-0ef8-4876-b732-4d5aeb3c19fa', company_user: tozawa, individual_user: sato, occupation: it },
  {id: '00d6d0b6-dd88-47c7-901f-b64bace12d64', company_user: tozawa, individual_user: sato, occupation: pm },
  {id: '027a5c61-8955-46b0-988c-4bd4e0e017f9', company_user: sawada, individual_user: sato, occupation: se },
  {id: '039a7b8e-7b94-4038-a98c-4799a29da710', company_user: tozawa, individual_user: suzuki, occupation: pm },
  {id: '05295c27-a759-4c51-b8fd-bddd983910ea', company_user: kaneko, individual_user: suzuki, occupation: infra },
  {id: '05598d10-f455-4953-9299-aae8af9158cd', company_user: sawada, individual_user: suzuki, occupation: se },
  {id: '058a210f-31dd-485c-b4c1-40fd81733aac', company_user: tozawa, individual_user: takahashi, occupation: sales },
  {id: '0af2fba2-bdb7-4adb-8928-89d166e37344', company_user: kaneko, individual_user: takahashi, occupation: eigyo},
  {id: '0ce87148-ca99-4d37-9467-ee9052f83bb0', company_user: sawada, individual_user: takahashi, occupation: inside},
  {id: '225360b4-76f1-412c-846c-a91847d35a69', company_user: tozawa, individual_user: nakamura, occupation: sales},
  {id: '2446652c-f9c2-4342-8927-5202318f9700', company_user: sawada, individual_user: nakamura, occupation: inside},
)
