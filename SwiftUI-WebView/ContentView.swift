//
//  ContentView.swift
//  SwiftUI-WebView
//
//  Created by Vamsi Kallepalli on 10/15/24.
//

import SwiftUI


// Define the data models
struct CourseContent: Identifiable, Codable {
    var id: Int?
    var name: String?
    var sequenceId: Int?
    var contentInfo: [ContentInfo]?
    var courseContents: [CourseContent]?
    var articleHeaders: [ArticleHeader]?
    var userArticleInfo: [UserArticleInfo]?
}

struct ContentInfo: Identifiable, Codable {
    var contentId: Int?
    var sequenceId: Int?
    
    // Computed property to satisfy the Identifiable protocol
    var id: Int? {
        return contentId
    }
}

struct ArticleHeader: Identifiable, Codable {
    var id: Int
    var title: String?
}

struct UserArticleInfo: Identifiable, Codable {
    var id: Int
    var userName: String?
}


// Sample nested data for testing the split view
let sampleCourseContents: [CourseContent] = [
    CourseContent(
        id: 1,
        name: "Swift Programming Basics",
        sequenceId: 1,
        contentInfo: [
            ContentInfo(contentId: 101, sequenceId: 1),
            ContentInfo(contentId: 102, sequenceId: 2)
        ],
        courseContents: [
            CourseContent(
                id: 11,
                name: "Introduction to Swift",
                sequenceId: 1,
                articleHeaders: [
                    ArticleHeader(id: 1001, title: "Getting Started with Swift")
                ]
            ),
            CourseContent(
                id: 12,
                name: "Basic Syntax",
                sequenceId: 2,
                articleHeaders: [
                    ArticleHeader(id: 1002, title: "Understanding Swift Syntax"),
                    ArticleHeader(id: 1003, title: "Swift Variables and Constants")
                ]
            )
        ],
        articleHeaders: [
            ArticleHeader(id: 1004, title: "Overview of Swift Language")
        ],
        userArticleInfo: [
            UserArticleInfo(id: 1, userName: "John Doe"),
            UserArticleInfo(id: 2, userName: "Jane Smith")
        ]
    ),
    CourseContent(
        id: 2,
        name: "Advanced Swift Programming",
        sequenceId: 2,
        contentInfo: [
            ContentInfo(contentId: 201, sequenceId: 1)
        ],
        courseContents: [
            CourseContent(
                id: 21,
                name: "Protocols and Delegates",
                sequenceId: 1,
                articleHeaders: [
                    ArticleHeader(id: 2001, title: "Swift Protocols"),
                    ArticleHeader(id: 2002, title: "Using Delegates in Swift")
                ]
            ),
            CourseContent(
                id: 22,
                name: "Memory Management",
                sequenceId: 2,
                articleHeaders: [
                    ArticleHeader(id: 2003, title: "Understanding ARC in Swift")
                ]
            )
        ],
        articleHeaders: [
            ArticleHeader(id: 2004, title: "Swift Advanced Concepts")
        ]
    )
]


struct ContentView: View {
    let courseContents: [CourseContent] = sampleCourseContents
    @State private var selectedArticleURL: URL?
    @State private var leftMenuWidth: CGFloat = 250  // Initial width of the left pane

    var body: some View {
        HStack(spacing: 0) {
            // Left pane: Course content list with expandable items
            List(courseContents, children: \.courseContents) { course in
                CourseContentRow(courseContent: course) { url in
                    // Set the selected URL for the web view when an article is selected
                    selectedArticleURL = url
                }
            }
            .frame(width: leftMenuWidth)
            .background(Color(.systemGroupedBackground))

            // Draggable divider for resizing
            Divider()
                .frame(width: 5)
                .background(Color.gray.opacity(0.5))
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let newWidth = leftMenuWidth + value.translation.width
                            leftMenuWidth = max(150, min(newWidth, 400))  // Set min and max width
                        }
                )

            // Right pane: WebViewContainer displaying selected article
            if let url = selectedArticleURL {
                WebViewContainer(url: url)
            } else {
                Text("Select an article to view details")
                    .foregroundColor(.gray)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CourseContentRow: View {
    let courseContent: CourseContent
    var onArticleSelected: (URL) -> Void  // Callback for selecting an article
    
    var body: some View {
        VStack(alignment: .leading) {
            if let name = courseContent.name {
                Text(name)
                    .font(.headline)
                    .listRowSeparator(.hidden)
            }
            
            if let sequenceId = courseContent.sequenceId {
                Text("Sequence ID: \(sequenceId)")
                    .font(.subheadline)
                    .listRowSeparator(.hidden)
            }
            
            // Nested article headers with selection handling
            if let articleHeaders = courseContent.articleHeaders, !articleHeaders.isEmpty {
                DisclosureGroup("Article Headers") {
                    ForEach(articleHeaders) { header in
                        if let title = header.title {
                            Button(action: {
                                // Sample URL generation; replace with actual URL logic
                                if let id = header.id as? Int, let url = URL(string: "https://example.com/article/\(id)") {
                                    onArticleSelected(url)
                                }
                            }) {
                                Text("Title: \(title)")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                                    .listRowSeparator(.hidden)
                            }
                            .padding(.leading)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}




