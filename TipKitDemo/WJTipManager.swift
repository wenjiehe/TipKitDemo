//
//  WJTipManager.swift
//  TipKitDemo
//
//  Created by 贺文杰 on 2024/5/27.
//

import Foundation
import TipKit

//自定义Tip
struct InlineTip : Tip { //继承Tip，Tip是一个协议，title是必须实现的属性
    var title: Text{
        Text("save as a favorite")
    }
    
    var message: Text? {
        Text("your favorite backyards always appear at the top of the list.")
    }
    
    var image: Image? {
        Image(systemName: "star")
    }
    
    var actions: [Action]{
        [
            Action(id: "id_more", title: "更多"){
                print("点击更多")
            },
            Action(id: "id_dismiss", title: "关闭"){
                print("点击关闭")
            }
        ]
    }
    
    @Parameter
    // 1. 基于参数规则
    static var showTip: Bool = false
    // 2. 基于事件规则
    static let appOpenedCount = Event(id: "appOpenedCount")
    var rules: [Rule]{
        [
            #Rule(Self.$showTip) { $0 == true }, // showTip为true
            #Rule(Self.appOpenedCount) { $0.donations.count >= 5 } //打开超过3次
        ]
    }
    
    var options: [any TipOption] {
        [
            Tip.IgnoresDisplayFrequency(true), // 忽略显示频率限制即立即显示
            Tip.MaxDisplayCount(5) // 最大显示次数
        ]
    }
}

struct operationTip : Tip{
    var title: Text{
        Text("操作提示")
            .foregroundStyle(.red)
            .font(.title2)
            .fontDesign(.serif)
            .bold()
    }
    
    var message: Text? {
        Text("通过触摸屏幕显示TipKit")
            .foregroundStyle(.white)
            .font(.title3)
            .fontDesign(.monospaced)
    }
    
    var asset: Image? {
        Image(systemName: "info.bubble")
    }
}
