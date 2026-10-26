# 原始项目命名提取清单

读取来源：`/Users/linqian/Documents/SuliJoy/reports/metallic-naming/staged-source`

使用 Swift 编译器 `-frontend -dump-parse` 解析项目源文件；不修改原工程，不包含 Pods、构建产物或第三方库声明。
所有拼写及大小写均保留原样。按源文件中的声明提取，不根据文件名推测类名。

Swift 文件：1；类声明：1；声明记录：53；去重名称：27；资源名称：0。

## 分类统计

- argument_label: 3
- binding_pattern: 17
- class: 1
- function: 10
- local_variable: 17
- parameter: 5

## 文件说明

- `class_names.txt`：去重类名，每行一个。
- `classes.csv`：类及所在源文件和行号，包含私有/嵌套类。
- `types.csv`：类、结构体、枚举、协议、类型别名及扩展目标。扩展系统类型不等于自主创建该类型。
- `functions.csv`：函数、方法、构造/析构及下标，保留参数标签组成的完整名称。
- `properties_and_variables.csv`：属性、全局变量和局部变量。
- `parameters_and_enum_cases.csv`：具名参数、编译器显式泛型参数、外部参数标签及枚举成员；排除隐式 $0 / $1。
- `binding_patterns.csv`：额外保留编译器的绑定模式名称，补充 for/catch、闭包等绑定；与变量清单有重叠，位置按外层范围定位。
- `declared_names.txt`：声明基础名称去重集合，移除语言固定基础名称、扩展目标和显式 override 名称；协议方法仍可能在其中。
- `all_declarations.csv` / `inventory.json`：完整声明、分类、作用域及可复查位置；JSON 含源文件 SHA-256。
- `asset_names.csv` / `source_filenames.txt`：资源目录名称及 Swift 文件名称。

## 自主命名的边界

源文件内存在的名字不必然都是自主创造：UIKit 协议回调、CodingKeys、AppDelegate、通用属性名等也可能由系统约定。
保留这些声明便于完整核对；classification 字段标记显式 override、语言固定名及扩展目标。未进行完整类型检查，不能自动证明每个协议方法的命名来源。
参数若没有独立源码范围，行号指向其外层声明，location_basis 标记为 enclosing_declaration；同名/同一行参数可能合并。
不将调用到的 UIKit 方法、注释和字符串当成自主声明。不提取密码、Token、请求内容、文案或资源文件内容。
此清单基于编译器输出的声明和绑定模式；不包含编译器未作为显式声明输出的语法名称或条件编译中未激活分支的完整语义。

## 所有类

- `SuliJoymetallicThreadController` — `SuliJoymetallicThreadController.swift:3`
