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
        ScrollView {
            if let station = vm.selectedStation {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(station.name)駅")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(station.line)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 8) {
                            Button(action: {
                                vm.resetNavi()
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            
                            Text("距離: \(station.distance)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    
                    Text("交通手段を選択")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    VStack(spacing: 12) {
                        transportTypeBtn(
                            action: {
                                vm.startNavigation()
                            },
                            imgName: "figure.walk",
                            time: vm.walkingEstimatedTime,
                            label: "徒歩"
                        )
                        transportTypeBtn(
                            action: {
                                vm.startNavigation()
                            },
                            imgName: "car",
                            time: vm.drivingEstimatedTime,
                            label: "車"
                        )
                        transportTypeBtn(
                            action: {
                                vm.startNavigation()
                            },
                            imgName: "tram.fill",
                            time: vm.transitEstimatedTime,
                            label: "電車"
                        )
                    }
                }
                .padding()
            }
        }
        .onAppear {
            vm.walkToStation()
            vm.driveToStation()
            vm.transitToStation()
        }
    }
}

extension StationInfoView {
    func transportTypeBtn(action: @escaping () -> Void, imgName: String, time: Int?, label: String) -> some View {
        Button(action: action) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemBlue).opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: imgName)
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    if let time = time {
                        Text("約 \(time) 分")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("取得中…")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray5)))
        }
    }
}



#Preview {
    StationInfoView(vm: ContentViewModel())
}
