# Websites
Here are some websites I made. Currently, they are built under the frame of R package (e.g. `shiny`, `bookdown`, `rmarkdown`), and deployed on shinyapps.io or bookdown.org.

這裡會放上我製作的網站，目前都使用R套件的框架來製作(例如`shiny`, `bookdown`, `rmarkdown`)，並發布於shinyapps.io或是bookdown.org

___
# Content
<details>
  <summary>[Bookdown] Time Series</b> (112-1 時間數列分析) Visit it at https://bookdown.org/k408651759/bookdown-TS/ :D</summary>
  <br>
  Personal note for <i>Time Series</i> course.
  <hr>
</details>
<br>
<details>
  <summary>[Bookdown] Recommender System</b> (112-1 推薦系統) Visit it at https://bookdown.org/k408651759/bookdown-RS/ -w-</summary>
  <br>
  Personal note for <i>Recommender System</i> course.
  <hr>
</details>
<br>
<details>
  <summary>[Shiny] YouBike</b> (112-2 程式語言: Python) Visit it at https://zihyingli.shinyapps.io/Python/ OUO</summary>
  <br>
  
  - Alternatively, if you have R installed, you can use the following code to open the website.

```
library(shiny)
runGitHub(repo="Python-Youbike", username="Zih-Ying", ref="main")
```

  - The data is obtained using a Python web crawler, primarily focusing on Taipei City. Data is collected every hour. Currently, the dataset only covers 3 days. We analyze this data and build a website using the R Shiny framework to visualize it.
  - In the future, we plan to integrate YouBike's API to display real-time distribution maps of all stations.
</details>

___
<details>
  <summary>Note to myself</summary>
  <ol>
    <li>發佈到bookdown.org後記得改SHARING，不然其他人要登入才能看</li>
    <li>gms信箱</li>
    <li>TS/tmp裡面的要整理到bookdown</li>
  </ol>
</details>
