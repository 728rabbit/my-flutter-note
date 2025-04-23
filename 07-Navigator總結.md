`push`

**跳到新頁面**（可以回來）

`Navigator.push(context, MaterialPageRoute(builder: (_) => NewPage()));`

`pushNamed`

**用路由名跳頁**（routes設定好）

`Navigator.pushNamed(context, '/login');`

`pushReplacement`

**跳到新頁，關掉舊頁**（不能回去）

`Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewPage()));`

`pushNamedAndRemoveUntil`

**跳頁並移除特定條件以上的頁**

`Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);`

`pop`

**返回上一頁**（帶或不帶資料）

`Navigator.pop(context);`  
`Navigator.pop(context, '返回結果');`

`popUntil`

**一路返回到某個特定頁**

`Navigator.popUntil(context, ModalRoute.withName('/home'));`

`canPop`

**判斷是否可以 pop**（防止直接 crash）

`if (Navigator.canPop(context)) Navigator.pop(context);`

`maybePop`

**有需要時才 pop**（不能pop就不動）

`Navigator.maybePop(context);`



# 🛠 小小心法

場景

推薦用法

簡單跳頁

`push` 或 `pushNamed`

跳頁且不想回到上一頁

`pushReplacement`

跳頁且清空之前所有頁面

`pushNamedAndRemoveUntil`

返回上一頁

`pop`

返回到特定頁面

`popUntil`
