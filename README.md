## `{ggvast}` とは
* `{VAST}`の推定結果を作図するためのパッケージ
* `{VAST}`では`{FishStatsUtils}`を用いて作図をしているが，以下のような不便な点がある
  * 後日，Save.RDataを使って作図をすることができない
  * `{VAST}`や`{FishStatsUtils}`が変更されると，これまでのコードで作図ができなくなることがある
  * 軸の名前が変更できない
    * 推定指標値の年トレンドでは，y軸名が必ずmetric tonnesになる
    * 推定密度のマップでは，NorthtingやEastingで表示される
  * 推定密度のマップとリジェンドが別々のファイルになる
  * COGの変化がkmで表示される    
* `{ggvast}`はこれらの問題を解決し，様々なハビタット，生物，研究分野で`{VAST}`を使いやすくすることを目標としている

## 注意点
* あらかじめVASTのコードを編集する必要がある
  ```
  Data_Geostat = cbind(Data_Geostat, knot_i = Spatial_List[["knot_i"]])
  ```

  ⬇︎

  ```
  Data_Geostat = cbind(Data_Geostat, knot_i = Spatial_List[["knot_i"]], zone = Extrapolation_List[["zone"]])
  write.csv(Data_Geostat, "Data_Geostat.csv")
  ```
* 複数種で解析する場合は[複数種の例題](https://github.com/James-Thorson-NOAA/VAST/blob/master/deprecated_examples/VAST--multispecies_example.Rmd)にならい，Data_Geostatの種に関する列名を**spp** とする
  ```
  Data_Geostat = data.frame( "spp"=DF[,"Sci"], "Year"=DF[,"Year"], "Catch_KG"=DF[,"Wt"], "AreaSwept_km2"=0.01, "Vessel"=0, "Lat"=DF[,"Lat"], "Lon"=DF[,"Long"] )
  ```


* 関数は書き終えたが，パッケージ化に必要な種々のファイル（例えばDESCRIPTIONやマニュアル）の作成が間に合っていない（パッケージ作りが初めてな上に一人で作っているので，作業スピードは亀です．．．）
* **パッケージ化までは，pre_Rフォルダ内のRコードをコピペして使う**
* `{ggvast}`に含まれる関数と関数から作成される図表は，『`{ggvast}` に含まれる関数』を参照
* ご意見ご要望はissueまで

## 例題
* [VASTのコード](https://gist.github.com/Yuki-Kanamori/42d04d6235170f27e6d7dfce589722a2)    
    [VASTのマニュアル](https://github.com/James-Thorson-NOAA/VAST/blob/master/deprecated_examples/VAST--single-species_example.Rmd) をきちんと動くように修正したもの
* [作図コード](url)

## インストール方法
* 準備中

## `{ggvast}` に含まれる関数
* #### `map_cog()`   
  COGを地図上にプロットする．VASTの推定COGとノミナルデータ両方に対応．ノミナルデータのCOGをプロットする場合には，**先に`get_cog()`でCOGを計算する必要がある**
  * 関数チェック済: VASTの推定COG（単一種・複数種）
  ![map_cog](figures/meps_fig4.png)
* #### `get_cog()`    
  ノミナルデータからCOGを計算し，データフレームを作成する    
  * 関数チェック済: 単一種・複数種    
    ![get_cog](figures/get_cog.png)
* #### `get_dens()`    
  `Save.RData`から各knotごとの推定値を抽出し，データフレームを作成する
  * 関数チェック済: 単一種・複数種    
    ![get_dens](figures/get_dens.png)
* #### `map_dens()`    
  アバンダンスを地図上にプロットする．VASTの推定値とノミナルデータの両方に対応．VASTの推定値をプロットする場合には，**先に`get_dens()`で`Save.RData`から推定値を抽出する必要がある**    
  **> 0データのみをプロットしたい場合には，> 0データのみのデータフレームを作成し関数にわたす**
  * 関数チェック済: VASTの推定COG（単一種・複数種），ノミナル（単一種・複数種）
  ![map_dens](figures/stock_asessment_fig33.png)
* #### `plot_index()`    
  推定された指標値（`Table_for_SS3.csv`）とノミナル指標値を一つの図にプロットする．推定指標値が複数（つまりVASTの結果が複数）の場合も作図可能．**現在のところカテゴリーが複数ある場合には対応していない**
  ![map_dens](figures/stock_asessment_fig32.png)

## 参考資料
### vastのコード
* 複数のカテゴリーで解析した例（masaVAST）
* catchability covariateに他種の密度，overdispersion configに年と月の交互作用を入れた例（[gomasaVAST](https://github.com/Yuki-Kanamori/gomasaVAST)）
* 共変量に水温を入れた例（masaVAST_NPFC2018）
* catchability covariateに漁具を入れた例（chiVAST）

### `{ggvast}`を使った論文・ドキュメント
* Kanamori Y, Takasuka A, Nishijima S, Okamura H (2019) Climate change shifts the spawning ground northward and extends the spawning period of chub mackerel in the western North Pacific. MEPS 624:155–166
https://doi.org/10.3354/meps13037
* Kanamori Y, Takasuka A, Nishijima S, Ichinokawa M, Okamura H (2019) Standardizing abundance index for spawning stock biomass of chub mackerel in the Northwest Pacific. NPFC-2018-TWG CMSA02-WP03
* 令和元 (2019) 年度ゴマサバ太平洋系群の資源評価    
http://abchan.fra.go.jp/digests2019/index.html （アップ待ち）



## 特記事項
* **`{ggvast}`は業務外の時間にパッケージ開発について学び作成しているもの（単なる趣味）です**
* **水研業務ではないため最終的には英語版としてパッケージ化します．悪しからず**
