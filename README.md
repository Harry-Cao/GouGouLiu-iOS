## Introduction
GouGouLiu is a app serves for the dog keepers who need help for walking their dogs. This repository is for GouGouLiu iOS client. For UI part, develop by UIKit and SwiftUI.

Mainly contain five modules:

<img width="368" alt="Snipaste_2024-03-20_14-53-14" src="https://github.com/Harry-Cao/GouGouLiu/assets/61426193/09419933-74f1-44bc-91a6-79cec9a2d693">

More details:
|Module|Home|Order|Publish|Message|Personal|
|-|-|-|-|-|-|
|Description|Showing users' posts about their pets with waterfall layout.|(Not finished yet) Showing users' orders for asking others to walk their dogs, anther part of users could pick the order to start earning money.|User could choose to publish posts and orders or anything else.|Message page contain system messages and user messages. For system messages, user could talk to Gemini, which is an powerful AI chat bot provided by Google. For user messages, support voice and video real-time comunication with Agora.|Showing user's personal info.|
|Main|![Simulator Screenshot - iPhone 15 Pro - 2024-03-20 at 14 39 41](https://github.com/Harry-Cao/GouGouLiu/assets/61426193/6eb08d5a-7add-4710-8de4-744ec1ce1bb7)|![Simulator Screenshot - iPhone 15 Pro - 2024-03-20 at 14 39 44](https://github.com/Harry-Cao/GouGouLiu/assets/61426193/35ba96fd-94df-48fc-9c0f-b77e9f1b8028)|![Simulator Screenshot - iPhone 15 Pro - 2024-03-20 at 14 39 48](https://github.com/Harry-Cao/GouGouLiu/assets/61426193/b3ddd15d-46ac-4846-b6cf-cd1aa7f26bc5)|![Simulator Screenshot - iPhone 15 Pro - 2024-03-20 at 14 40 00](https://github.com/Harry-Cao/GouGouLiu/assets/61426193/d67a4e2f-64d6-4b84-8d2f-e25c055bd73e)|<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-12-17 at 22 49 34" src="https://github.com/user-attachments/assets/a701f472-349a-4211-911a-b1b4d34519aa" />|
|-|![Simulator Screenshot - iPhone 15 Pro - 2024-03-20 at 14 41 03](https://github.com/Harry-Cao/GouGouLiu/assets/61426193/1caa990d-b9aa-4574-944c-ad450e2b498e)|-|-|![Simulator Screenshot - iPhone 15 Pro - 2024-05-09 at 02 05 56](https://github.com/Harry-Cao/GouGouLiu-iOS/assets/61426193/001e5dce-763e-4dd9-bd35-ae3b2fe4386d)|<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2025-12-17 at 22 48 01" src="https://github.com/user-attachments/assets/17f5f24c-9afa-4f53-8ec3-8bc5e5e2c880" />|
|-|-|-|-|![Simulator Screenshot - iPhone 15 Pro - 2024-05-09 at 02 07 21](https://github.com/Harry-Cao/GouGouLiu-iOS/assets/61426193/ab803e35-3780-4cd5-9545-5d075f325b31)|-|

## Download
```
git clone https://github.com/Harry-Cao/GouGouLiu.git
```

## Dependance
In this project, I use [cocoapods](https://cocoapods.org) and [swiftpm](https://www.swift.org/documentation/package-manager/) at the same time. So you still need to set up for dependances that installed by cocoapods.
```
pod install
```

## Google Generative AI

Gemini is plugged into this project. Gemini asks for an API_KEY, and google suggest to put API_KEY to a plist file and don't trace it. So you could see a [example plist](https://github.com/Harry-Cao/GouGouLiu/blob/main/GouGouLiu/GenerativeAI-Info-example.plist) in this project. You need to copy and rename it as **GenerativeAI-Info.plist**, and then replace **API_KEY_VALUE** with your **API_KEY**.
