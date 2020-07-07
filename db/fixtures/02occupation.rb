tozawa = User.find_by(email: 'tozawasoken@pca.com')
kaneko = User.find_by(email: 'kanekotoys@pca.com')
sawada = User.find_by(email: 'sawadashoten@pca.com')

Occupation.seed(:user_id,
  #戸澤総研
  {user: tozawa, name: 'ITコンサルタント', color: 'red', address: 'Web（Zoom）', apply_from: 1 , item: 'なし', memo: '面接官は3名で対応します。', required_time: 1 },
  {user: tozawa, name: 'PM', color: 'pink', address: '東京都千代田区丸の内2-4-1 丸の内ビルディング27F', apply_from: 0, item: '履歴書、職務経歴書、筆記用具', memo: 'これまで携わったプロジェクトについて詳細をお伺いします。', required_time: 1},
  {user: tozawa, name: 'sales manager', color: 'purple', address: '東京都千代田区丸の内2-5-2 三菱ビル8F', apply_from: 0 , item: '履歴書、職務経歴書、筆記用具', memo: '営業本部長との面接です。', required_time: 1.5},
  #KANEKOトイズファクトリー
  {user: kaneko, name: 'インフラエンジニア', color: 'orange', address: '東京都港区南青山1-15-5　パーソル南青山ビル', apply_from: 0 , item: '履歴書原本（写真付き）と職務経歴書、筆記用具、メモ', memo: 'なし', required_time: 1},
  {user: kaneko, name: '生産管理', color: 'gray', address: '神奈川県横浜市西区みなとみらい3-6-3 MMパークビル6F', apply_from: 1, item: '履歴書原本（写真付き）と職務経歴書、筆記用具、メモ', memo: '適性検査+面接の予定', required_time: 2},
  {user: kaneko, name: '営業アシスタント', color: 'yellow', address: '東京都港区南青山1-15-5　パーソル南青山ビル', apply_from: 1 , item: '履歴書原本（写真付き）と職務経歴書、筆記用具、メモ', memo: 'なし', required_time: 0.5},
  #澤田商店
  {user: sawada, name: 'インサイドセールス', color: 'green', address: 'Web（Zoom）', apply_from: 1, item: 'なし', memo: 'インサイドセールスマネージャーとの面接です。', required_time: 1},
  {user: sawada, name: '経理', color: 'teal', address: '東京都台東区柳橋1-4-4 ツイントラスビル3F', apply_from: 1, item: '筆記用具', memo: '2時間の筆記試験+面接', required_time: 3},
  {user: sawada, name: '社内SE', color: 'indigo', address: '東京都台東区柳橋1-4-4 ツイントラスビル3F', apply_from: 0 , item: '筆記用具', memo: 'なし', required_time: 1},

)