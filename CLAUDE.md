# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Running the Application
```bash
# Quick start using shell script
chmod +x run.sh
./run.sh

# Manual start
cd backend && uv run uvicorn app:app --reload --port 8000
```

### Environment Setup
```bash
# Install dependencies
uv sync

# Add new dependencies (use uv instead of pip)
uv add package_name

# Environment variables required
# Create .env file with:
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

### Python Execution
Always use `uv` for running Python files and commands:
```bash
# Run Python scripts
uv run python script.py

# Run any Python command
uv run command_name
```

### Code Quality Tools
Code quality tools are configured in pyproject.toml with Black, isort, flake8, and mypy:
```bash
# Format code and run all quality checks
./scripts/format.sh

# Run linting and type checking only (read-only)
./scripts/lint.sh

# Individual commands
uv run black backend/ main.py    # Format code
uv run isort backend/ main.py    # Sort imports
uv run flake8 backend/ main.py   # Lint code
uv run mypy backend/ main.py     # Type checking
```

### Application Access
- Web Interface: http://localhost:8000
- API Documentation: http://localhost:8000/docs

## Architecture Overview

This is a Retrieval-Augmented Generation (RAG) system for course materials with a FastAPI backend and vanilla JavaScript frontend.

### Core Components

**RAGSystem (backend/rag_system.py)**: Main orchestrator that coordinates all components
- Manages document processing, vector storage, AI generation, and search tools
- Handles course document ingestion from the docs/ directory
- Processes queries using tool-based search approach

**VectorStore (backend/vector_store.py)**: ChromaDB-based vector storage with dual collections
- `course_catalog`: Stores course titles for name resolution
  - Metadata: title, instructor, course_link, lesson_count, lessons_json (list of lessons with lesson_number, lesson_title, lesson_link)
- `course_content`: Stores text chunks for semantic search
  - Metadata: course_title, lesson_number, chunk_index
- Supports filtered search by course name and lesson number

**AIGenerator (backend/ai_generator.py)**: Anthropic Claude API integration
- Uses claude-sonnet-4-20250514 model
- Implements tool calling for search functionality
- Maintains conversation history via SessionManager

**Search Tools (backend/search_tools.py)**: Tool-based search system
- CourseSearchTool: Semantic search across course content with intelligent course name resolution
- ToolManager: Manages tool registration and execution for AI model

### Data Flow
1. Course documents (PDF, DOCX, TXT) are loaded from docs/ directory on startup
2. DocumentProcessor chunks content and extracts course metadata
3. VectorStore stores both metadata and content in separate ChromaDB collections
4. User queries trigger AI generation with access to search tools
5. AI uses CourseSearchTool to find relevant content and generates responses
6. Frontend displays responses with source attribution

### Key Configuration (backend/config.py)
- Chunk size: 800 characters with 100 character overlap
- Embedding model: all-MiniLM-L6-v2 (SentenceTransformers)
- Max search results: 5 per query
- Conversation history: 2 message pairs

### Frontend Architecture
- Single-page application with vanilla JavaScript
- Real-time course statistics display
- Markdown rendering support for AI responses
- Responsive design with sidebar for course info and suggested queries

## Development Notes

- The system automatically loads documents from docs/ on startup
- ChromaDB data persists in backend/chroma_db/
- FastAPI serves both API endpoints (/api/*) and static frontend files
- CORS is configured for development with broad permissions
- No-cache headers are set for static files during development