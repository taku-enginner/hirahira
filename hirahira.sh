#!/bin/bash
###########################################
# 注意点
# ・ターミナルのサイズが小さすぎると、画面崩れが起こる場合があります。
# ・Ctrl + cで強制終了した場合は、`tput cnorm`を実行してからターミナルを操作してください。
###########################################


# 落ち葉1枚
# x座標：y座標：x方向の速度：周期
ochiba=(20 3 1 2)

max_x=$(tput cols)
max_y=$(tput lines)

tput clear
tput civis

text=('----------------------------' '||__RUNTEQミニアプリWeek__||' '||タイトル：ひらひら落ち葉||' '----------------------------')
RUNTEQ_Y=$(($max_y/2))
RUNTEQ_X=$(($max_x/2))
for i in ${text[@]}
do
  tput cup "$RUNTEQ_Y" "$RUNTEQ_X" && echo "$i"
  RUNTEQ_Y=$(($RUNTEQ_Y + 1))
done

# 木を書く
tree_y=0
for i in $(seq 0 $max_y)
do
  # 木の枝の部分
  # 上の方
  if [ $tree_y -le 2 ]; then
    tput cup $tree_y "${ochiba[1]}"  && echo '---------------------------------------------------------------------------'
  elif [ $tree_y -le 4 ]; then
    tput cup $tree_y "${ochiba[1]}"  && echo '-------------------------------------------------'
  fi

  # 根の部分
  if [ $tree_y -gt $(( $max_y - 6 )) ] && [ $tree_y -le $(( $max_y - 5 )) ]; then
      tput cup $tree_y 0 && echo '\\\\\'
  elif [ $tree_y -gt $(( $max_y - 5 )) ] && [ $tree_y -le $(( $max_y - 4 )) ]; then
      tput cup $tree_y 0 && echo '\\\\\\\\\\'
  elif [ $tree_y -gt $(( $max_y - 4 )) ] && [ $tree_y -le $(( $max_y - 3 )) ]; then
      tput cup $tree_y 0 && echo '\\\\\\\\\\\\\\\'
  elif [ $tree_y -gt $(( $max_y - 3 )) ] && [ $tree_y -le $(( $max_y - 2 )) ]; then
      tput cup $tree_y 0 && echo '\\\\\\\\\\\\\\\\\\\\'
  elif [ $tree_y -gt $(( $max_y - 2 )) ] && [ $tree_y -le $(( $max_y - 1 )) ]; then
      tput cup $tree_y 0 && echo '\\\\\\\\\\\\\\\\\\\\\\\\'
  elif [ $tree_y -eq $max_y ]; then
      #tput cup $tree_y 0 && echo '\*' * $max_x
      tput cup $tree_y 0 && printf '%*s\n' "$max_x" '' | tr ' ' '*'
  else
    # 幹の部分
    tput cup $tree_y 0 && echo '|||||'
  fi
  tree_y=$(($tree_y + 1))
done

tput cup "${ochiba[1]}" "${ochiba[0]}" && echo "#"
for i in $(seq 1 $(($max_y - "${ochiba[1]}" - 3)))
do
  sleep 0.2
  # 1つ前の位置を消す
  tput cup "${ochiba[1]}" "${ochiba[0]}" && echo " "
  # x方向の速度計算
  tmp_i=$(echo "scale=5; s(${i}/5) * s(${i}/7)" | bc -l)
  ochiba[2]=$(echo "scale=5; s(${tmp_i}*10/${ochiba[3]})" | bc -l)
  # x方向の速度を整数に変換
  ochiba[2]=$(printf "%.0f" "${ochiba[2]}")
  # x座標更新
  ochiba[0]=$((${ochiba[0]}+${ochiba[2]}*2))
  # y座標更新
  ochiba[1]=$((${ochiba[1]}+1))
  # 描画
  tput cup "${ochiba[1]}" "${ochiba[0]}" && echo "#"
done

tput cup "$RUNTEQ_Y" "$RUNTEQ_X" && echo "遊んでいただき、ありがとうございました！" && RUNTEQ_Y=$(($RUNTEQ_Y + 1))
tput cnorm
count=10
ctrlc_y=$(($RUNTEQ_Y + 1))
for i in $(seq 1 10)
do
  tput cup "$RUNTEQ_Y" "$RUNTEQ_X" && echo "$count 秒後に終了します。"
  tput cup "$ctrlc_y" "$RUNTEQ_X" && echo "Ctrl + cで即終了 (カーソルが見えない場合は、tput cnorm を実行してください)"
  sleep 1
  count=$(($count - 1))
done

tput clear
