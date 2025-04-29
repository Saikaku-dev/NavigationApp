//
//  StationInfoView.swift
//  IOS202map_39
//
//  Created by cmStudent on 2025/04/29.
//

import SwiftUI

struct StationInfoView: View {
    @Bindable var vm: ContentViewModel
    
    var body: some View {
        HStack {
            if let station = vm.selectedStation {
                VStack(alignment: .leading) {
                    Text("\(station.name)駅")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("\(station.line)")
                        .font(.subheadline)
                }
                .fixedSize()
                Spacer()
                VStack(alignment: .trailing) {
                    Button("閉じる") {
                        vm.showStationDeatil = false
                        vm.resetTime()
                    }
                    Text("距離：\(station.distance)")
                        .font(.body)
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear() {
            vm.walkToStation()
            vm.driveToStation()
            vm.transitToStation()
        }
        
        HStack {
            transportTypeBtn(
                action: {
                    vm.startNavigation()
                },
                imgName: "figure.walk",
                time: vm.walkingEstimatedTime
            )
            
            transportTypeBtn(
                action: {
                    vm.startNavigation()
                },
                imgName: "car",
                time: vm.drivingEstimatedTime
            )
            
            transportTypeBtn(
                action: {
                    vm.startNavigation()
                },
                imgName: "tram.fill",
                time: vm.transitEstimatedTime
            )
        }
    }
}

extension StationInfoView {
    func transportTypeBtn(action: @escaping () -> Void, imgName: String, time: Int?) -> some View {
        VStack(spacing: 8) {
            Button(action: action) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: imgName)
                        .foregroundColor(.blue)
                        .font(.system(size: 24, weight: .semibold))
                }
            }

            if let time = time {
                Text("約 \(time) 分")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            } else {
                Text("取得中…")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    StationInfoView(vm: ContentViewModel())
}
