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
  {id: '0d690ade-d829-42cc-850e-86e57e77d100', company_user: kaneko, individual_user: tanaka, occupation: seisan},
  {id: '0eaa19e4-7948-43a8-b6b6-42bb3e36e765', company_user: sawada, individual_user: tanaka, occupation: keiri},
  {id: '0f218026-0695-4367-8375-bbe904c725ae', company_user: sawada, individual_user: ito, occupation: keiri},
  {id: '12d22ae2-b6f1-43c2-b1ba-095cec586169', company_user: sawada, individual_user: ito, occupation: inside},
  {id: '1318f511-43d3-4e6b-8e34-5de0e783a4b4', company_user: kaneko, individual_user: ito, occupation: eigyo},
  {id: '13e567c1-e23e-4f5a-943e-ece6325d6c26', company_user: kaneko, individual_user: yamamoto, occupation: eigyo},
  {id: '144e6492-95c2-4cbf-bdc8-1173372007d5', company_user: sawada, individual_user: yamamoto, occupation: inside},
  {id: '1ee48023-e083-4906-a424-77a1487c0b02', company_user: sawada, individual_user: yamamoto, occupation: keiri},
  {id: '225360b4-76f1-412c-846c-a91847d35a69', company_user: tozawa, individual_user: nakamura, occupation: sales},
  {id: '2446652c-f9c2-4342-8927-5202318f9700', company_user: sawada, individual_user: nakamura, occupation: inside},
)
