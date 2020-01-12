## Description
* `{VAST}`の推定結果を作図するためのパッケージです
* `{VAST}`では`{FishStatsUtils}`を用いて作図をしていますが，以下のような不便な点がある
  * 後日，Save.RDataを使って作図をすることができない
  * `{VAST}`や`{FishStatsUtils}`が変更されると，これまでのコードで作図ができなくなることがある
  * 軸の名前が変更できない
    * 推定指標値の年トレンドでは，y軸名が必ずmetric tonnesになる
    * 推定密度のマップでは，NorthtingやEastingで表示される
  * 推定密度のマップとリジェンドが別々のファイルになる
  * COGの変化がkmで表示される    
* `{ggvast}`はこれらの問題を解決し，国内の資源評価でも`{VAST}`を使いやすくすることを目指しています    
* 関数は書きあげたのですが，パッケージ化に必要な種々のファイル（例えばDESCRIPTIONやマニュアル）の作成が間に合っておりません（パッケージ作りは初めてな上に一人で作っているので，作業スピードは亀です．．．）
* **パッケージ化までは，pre_Rフォルダ内のRコードをコピペして使ってください**
* `{ggvast}`に含まれる関数と関数から作成される図表は，Functionsをご覧下さい
* ご意見ご要望はissueまで

## Installation instruction
* 準備中

## Functions
* `map_cog()`: COGを地図上にプロットする（推定値のみに対応．ノミナルデータでも描けるように拡張中）
![map_cog](figures/meps_fig4.png)
* `get_dens()`: `Save.RData`から各knotごとの推定密度を抽出し，データフレームを作成する
* `map_dens()`: `get_dens`で作成したデータフレームから推定密度のマップを作成する（推定値のみに対応．ノミナルデータでも描けるように拡張中）  
![map_dens](figures/stock_asessment_fig33.png)
* `plot_index`: `{VAST}`から推定された指標値とノミナル指標値を一つの図にプロットする

## Example figures
* Kanamori Y, Takasuka A, Nishijima S, Okamura H (2019) Climate change shifts the spawning ground northward and extends the spawning period of chub mackerel in the western North Pacific. MEPS 624:155–166
https://doi.org/10.3354/meps13037
