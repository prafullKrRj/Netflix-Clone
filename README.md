# Netflix Clone Flutter App

A Flutter application that demonstrates movie browsing and searching capabilities using the TVMaze API. Built with Flutter and Riverpod for state management.

## Features

- 🎬 Browse popular movies and TV shows
- 🔍 Search functionality with real-time results
- 📱 Netflix-inspired UI/UX
- 📊 Detailed movie information including ratings and genres

## Screenshots

<div style="display: flex; justify-content: space-between; flex-wrap: wrap;">
    <img src="https://github.com/prafullKrRj/Netflix-Clone/blob/master/ss/Screenshot_20250111_120739.png?raw=true" alt="Home Screen" style="width: 30%; margin: 0.5%;" />
    <img src="https://github.com/prafullKrRj/Netflix-Clone/blob/master/ss/Screenshot_20250111_120831.png?raw=true" alt="Search Screen" style="width: 30%; margin: 0.5%;" />
    <img src="https://github.com/prafullKrRj/Netflix-Clone/blob/master/ss/Screenshot_20250111_120844.png?raw=true" alt="Details Screen" style="width: 30%; margin: 0.5%;" />
</div>

## Architecture

The app follows a clean architecture pattern with:
- Models for data representation
- Providers for state management (Riverpod)
- Screens for UI component

## Dependencies

- flutter_riverpod: ^2.4.0 - State management
- http: ^1.1.0 - API calls

## API Reference

This app uses the TVMaze API:
- Search shows: `https://api.tvmaze.com/search/shows?q=all`
- Search by term: `https://api.tvmaze.com/search/shows?q=${search_term}`
