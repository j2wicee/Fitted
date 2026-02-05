//
//  OutfitsView.swift
//  Fitted
//
//  Created by Joshua  Evans  on 2/5/26.
//

import Foundation
import SwiftUI
import SwiftData

struct OutfitsView : View{
    @Query(sort: \Outfit.dateCreated, order: .reverse) private var outfits:[Outfit]
    @State private var showingCreateOutfit = false
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View{
        NavigationStack{
            ScrollView{
                if outfits.isEmpty{
                    //Empty State
                    VStack(spacing: 16){
                        Image(systemName: "tshirt.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                            .padding(.top, 80)
                        
                        Text("No Outfits Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Create your first outfit to get started!")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal,40)
                    }
                    .frame(maxWidth: .infinity)
                } else{
                    LazyVGrid(columns: columns, spacing: 16){
                        ForEach(outfits){ outfit in
                            NavigationLink{
                              //  OutfitDetailView(outfit: outfit)
                            } label: {
                                OutfitTile(outfit: outfit)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Outfits")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showingCreateOutfit = true
                    } label : {
                        Image(systemName: "plus")
                        
                    }
                }
            }
            .sheet(isPresented: $showingCreateOutfit){
                OutfitBuilderView()
            }
        }
    }
}
