//
//  CarouselView.swift
//  Recorder
//
//  Created by 조은비 on 2022/06/13.
//

import SwiftUI

struct SnapCarousel: View {
    @State private var angle = 0.0 // cd ratation angle 초기값
    @EnvironmentObject var UIState: UIStateModel
    @State var showCd = false // cd player에 cd 나타나기
    @State var showDetailView = false // detailView 나타나기
    
    var body: some View {
        let spacing: CGFloat = -20
        let widthOfHiddenCds: CGFloat = 100
        let cdHeight: CGFloat = 279
        
        // 기록물 id, 곡제목, 가수명, 앨범커버 배열 예시
        let items = [
                    Cd(id: 0, musicTitle: "노래제목1", singer: "가수명1", image: "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/f7/68/9c/f7689ce3-6d41-60cd-62d2-57a91ddf5b9d/196922067341_Cover.jpg/100x100bb.jpg"),
                    Cd(id: 1, musicTitle: "노래제목2", singer: "가수명2", image: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/17/ff/63/17ff63de-3aba-0f2d-63e7-50d66f900ebb/21UMGIM43558.rgb.jpg/100x100bb.jpg"),
                    Cd(id: 2, musicTitle: "노래제목3", singer: "가수명3", image: "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/f7/68/9c/f7689ce3-6d41-60cd-62d2-57a91ddf5b9d/196922067341_Cover.jpg/100x100bb.jpg"),
                    Cd(id: 3, musicTitle: "노래제목4", singer: "가수명4", image: "https://is1-ssl.mzstatic.com/image/thumb/Music125/v4/17/ff/63/17ff63de-3aba-0f2d-63e7-50d66f900ebb/21UMGIM43558.rgb.jpg/100x100bb.jpg"),
                    Cd(id: 4, musicTitle: "노래제목5", singer: "가수명5", image: "https://is3-ssl.mzstatic.com/image/thumb/Music122/v4/f7/68/9c/f7689ce3-6d41-60cd-62d2-57a91ddf5b9d/196922067341_Cover.jpg/100x100bb.jpg")
        ]
        
        // https://gist.github.com/xtabbas/97b44b854e1315384b7d1d5ccce20623.js 의 샘플코드를 참고했습니다.
        return Canvas {
            if showDetailView {
                DetailView()
                    .transition(AnyTransition.opacity.animation(.easeInOut)) // 자연스러운 뷰 전환
            }else {
            ZStack {
                Color("background")
                    .ignoresSafeArea()
                // Carousel 슬라이더 기능
                // ForEach로 items마다 Item() 뷰를 각각 불러옴
                VStack {
                    Carousel(
                        numberOfItems: CGFloat(items.count),
                        spacing: spacing,
                        widthOfHiddenCds: widthOfHiddenCds
                    ) {
                        ForEach(items, id: \.self.id) { item in
                            Item(
                                _id: Int(item.id),
                                spacing: spacing,
                                widthOfHiddenCds: widthOfHiddenCds,
                                cdHeight: cdHeight
                            ) {
                                VStack {
                                    // activeCard를 id값으로 가진 가운데 cd만 타이틀을 가짐
                                    // 그 외의 카드는 높이를 동일하게 줄여주기 위해 빈 공간을 Item 범위에 포함시킴
                                    if(item.id == UIState.activeCard ) {
                                        Text("\(item.musicTitle) - \(item.singer)")
                                            .foregroundColor(Color.black)
                                            .padding(.bottom, 30)
                                    } else {
                                        Spacer()
                                            .frame(height: 50)
                                    }
                                    // cd(Item) 자체가 버튼으로 작동
                                    Button( action: {
                                        showCd = true // cdPlayer에 cd 보이기
                                    }) {
                                        ZStack {
                                          URLImage(urlString: item.image)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                            .shadow(color: Color(.gray), radius: 4, x: 0, y: 4)
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.background)
                                        }
                                    } // 버튼
                                } // V 스택
                            }
                            .transition(AnyTransition.slide)
                            .animation(.spring())
                        } // ForEach
                    }
                    .padding(.top, 150)
                    Spacer()
                    // CdPlayer
                        ZStack {
                            Image("cdPlayer")
                            // cd 클릭시, cdPlayer에 cd 나타남
                            VStack {
                                if showCd == true {
                                    URLImage(urlString: items[UIState.activeCard].image)
                                        .clipShape(Circle())
                                        .frame(width: 110, height: 110)
                                        .rotationEffect(.degrees(self.angle))
                                        .animation(.timingCurve(0, 0.8, 0.2, 1, duration: 10), value: angle)
                                        .onTapGesture {
                                            self.angle += Double.random(in: 1800..<1980)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                showDetailView = true
                                            }
                                        }
                                }
                            }
                            .padding(.bottom, 180)
                            .padding(.leading, 2) // CdPlayer를 그림자 포함해서 뽑아서 전체 CdPlayer와 정렬 맞추기 위함
                            // cdPlayer 가운데 원
                            VStack {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.titleLightgray)
                                        .frame(width: 30 , height: 30)
                                    Circle()
                                        .foregroundColor(.titleDarkgray)
                                        .frame(width: 15 , height: 15)
                                        .shadow(color: Color(.gray), radius: 4, x: 0, y: 4)
                                    Circle()
                                        .foregroundColor(.background)
                                        .frame(width: 3 , height: 3)
                                } // Z스택
                            } // V스택
                            .padding(.bottom, 180)
                            .padding(.leading, 4)
                        } // Z스택
                    } // V스택
                    .ignoresSafeArea()
                } // Z스택
            } // if문
        } // Canvas
    } // 바디 뷰
}

// 기록한 Cd의 데이터 구조체
struct Cd: Identifiable, Hashable {
    var id: Int
    var musicTitle: String = ""
    var singer: String = ""
    var image: String = ""
}

public class UIStateModel: ObservableObject {
    @Published var activeCard: Int = 0 // 가운데 위치한 cd의 id 값
    @Published var screenDrag: Float = 0.0 // 드래그하고 있는지 파악하기 위한 값
}

// 기록한 cd의 carousel 스크롤 뷰
struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat
    let spacing: CGFloat
    let widthOfHiddenCards: CGFloat
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false // 드래그하고 있는지 파악하기 위함
    
    @EnvironmentObject var UIState: UIStateModel
        
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCds: CGFloat,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCds
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCds * 2) - (spacing * 2)
    }
    
    var body: some View {
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
                
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)

        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            // 터치가 뒤로 50 이동(뒤로 드래그)하면서 activeCard가 마지막 값이 아닐때 다음 cd가 나옴
            if (value.translation.width < -50 && CGFloat(self.UIState.activeCard) < numberOfItems - 1) {
                self.UIState.activeCard = self.UIState.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred() // haptic 피드백
            }
            // 터치가 앞으로 50 이동(뒤로 드래그)하면서 activeCard가 처음 값이 아닐때 이전 cd가 나옴
            if (value.translation.width > 50 && CGFloat(self.UIState.activeCard) > 0) {
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred() // haptic 피드백
            }
        })
    }
}

// 스크롤되는 뷰
struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .background(Color.background.edgesIgnoringSafeArea(.all))
    }
}

// 기록한 cd의 뷰
struct Item<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cdWidth: CGFloat
    let cdHeight: CGFloat

    var _id: Int
    var content: Content

    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCds: CGFloat,
        cdHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cdWidth = UIScreen.main.bounds.width - (widthOfHiddenCds*2) - (spacing*2) // 중심에 있는 cd 넓이
        self.cdHeight = cdHeight
        self._id = _id
    }

    // 양옆에 있는 cd 높이만 줄여줌
    var body: some View {
        content
            .frame(width: cdWidth, height: _id == UIState.activeCard ? cdHeight : cdHeight - 60, alignment: .center)
    }
}