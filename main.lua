--アセットの取得
local wing       = vci.assets.GetSubItem("wing")
local daytimesky = vci.assets.GetSubItem("daytimesky")
local eveningsky = vci.assets.GetSubItem("eveningsky")
local nightsky   = vci.assets.GetSubItem("nightsky")
local skyswitch  = vci.assets.GetSubItem("skyswitch")

--空の切り替え用定数
local DAYTIME = 0
local EVENING = 1
local NIGHT   = 2

--時間帯ステータス用共有変数
timeZone = nil --呼び出した人がセット

if vci.assets.IsMine then -- 呼び出したユーザーが代表して初期化する(最初は昼)
    vci.state.Set("TIMEZONE", DAYTIME) 
end

if vci.state.Get("TIMEZONE") ~=nil then --現在の部屋の状態と同期
    timeZone = vci.state.Get("TIMEZONE")
end

--回転速度
local wingRotSpeed = 0.5	--帆の回転速度
local skyRotSpeed  = -0.05  --空の回転速度

function updateAll()

    --時間帯同期
    if timeZone == DAYTIME then --値の確認で通信は起こらない
        --print("空（昼）を横に回転させる")
        --空（昼）を横に回転させる（dayskyRotSpeedの値が速度）
        daytimesky.SetLocalRotation(Quaternion.AngleAxis(skyRotSpeed, daytimesky.GetUp()) * daytimesky.GetLocalRotation() )
    end

    if timeZone == EVENING then --値の確認で通信は起こらない
        print("空（夕方）を横に回転させる")
        --空（夕方）を横に回転させる（dayskyRotSpeedの値が速度）
        eveningsky.SetLocalRotation(Quaternion.AngleAxis(skyRotSpeed, eveningsky.GetUp()) * eveningsky.GetLocalRotation() )
    end

    if timeZone == NIGHT then --値の確認で通信は起こらない
        print("空（夜）を横に回転させる")
        --空（夜）を横に回転させる（dayskyRotSpeedの値が速度）
        nightsky.SetLocalRotation(Quaternion.AngleAxis(skyRotSpeed, nightsky.GetUp()) * nightsky.GetLocalRotation() )
    end

    --帆を横に回転させる（wingRotSpeedの値が速度）
    wing.SetLocalRotation(Quaternion.AngleAxis( wingRotSpeed, wing.GetForward() ) * wing.GetLocalRotation())
    

end

---[SubItemの所有権&Use状態]アイテムをグラッブしてグリップボタンを押すと呼ばれる。
---@param use string @押されたアイテムのSubItem名
function onUse(use) --アイテムを使用したときに実行
    if use == ("skyswitch") then
        print("時間帯を変更します。")
        if timeZone == DAYTIME then
            print("夕方にします。")
            --vci.state.Set("timeZone", true) --現在の部屋の状態を更新
            --vci.message.Emit("set_timeZone", true) --"set_timeZone"メッセージを各々の参加者に送信
        end
        if timeZone == EVENING then
            print("夜にします。")
        end
        if timeZone == NIGHT then
            print("昼にします。")
        end
    end
end



--function changeTimeZone(sender, name, message) --"set_timeZone"メッセージで実行される処理
--    flag = message --メッセージを受信したときにだけ値を更新
--end

--vci.message.On("set_timeZone", changeTimeZone) -- "set_timeZone"メッセージの受信を開始