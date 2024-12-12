//
//  CardsView.swift
//  TestCards
//
//  Created by Arun Doley on 11/12/2024.
//

import SwiftUI

struct CardsView: View {
    
    @StateObject private var viewModel: CardsViewModel = CardsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $viewModel.selectedCardCategory) {
                    ForEach(CardCategory.allCases, id: \.self) { option in
                        Text(option.rawValue)
                            .tag(option.rawValue)
                            .accessibilityIdentifier(option.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .accessibilityIdentifier("cardCategoryPicker")
                .padding()
                AsyncContentView(source: viewModel) { allCards in
                    let selectedCards = viewModel.selectedCardCategory == .allCards ? allCards.cards : allCards.savedCards
                    if selectedCards.isEmpty {
                        Text("No cards available.")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .accessibilityIdentifier("emptyStateLabel")
                            .padding()
                        Spacer()
                    } else {
                        List(selectedCards, id: \.cardId) { card in
                            cardView(for: card)
                                .padding(.vertical, 8)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(PlainListStyle())
                        .refreshable {
                            await viewModel.load()
                        }
                    }
                }
            }
            .task {
                await viewModel.load()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Cards")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                viewModel.sortOption = option
                            }) {
                                Label {
                                    Text(option.rawValue)
                                } icon: {
                                    if option == viewModel.sortOption {
                                        Image(systemName: "checkmark")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private func cardView(for card: UIOCard) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(card.cardNumber)
                    .font(.headline)
                    .bold()
                    .padding(.bottom, 4)
                    .accessibilityIdentifier("cardNumberLabel")
                Spacer()
                Button(action: {
                    Task {
                        if viewModel.isSaved(card) {
                            await viewModel.removeCard(card)
                        } else {
                            await viewModel.saveCard(card)
                        }
                    }
                }) {
                    Image(systemName: viewModel.isSaved(card) ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .padding(8)
                        .background(Circle().fill(Color.white))
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                .accessibilityIdentifier("saveCardButton")
            }
            
            HStack {
                Text("\(card.cardExpiryDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityIdentifier("expiryDateLabel")
                Spacer()
                Text("\(card.cardType)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .accessibilityIdentifier("cardTypeLabel")
            }
        }
        .padding()
        .background(
            Color.white
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
        )
    }
    
}
