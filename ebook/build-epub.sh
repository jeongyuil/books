#!/bin/bash

# 시간 위의 플랫폼 - ePub 빌드 스크립트
# 사용법: ./build-epub.sh

echo "=========================================="
echo "📚 시간 위의 플랫폼 ePub 빌드 시작"
echo "=========================================="

# 디렉토리 설정
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$SCRIPT_DIR/output"

# 출력 디렉토리 생성
mkdir -p "$OUTPUT_DIR"

# 입력 파일
INPUT_FILE="$PROJECT_DIR/그들은 당신이 뭘 볼지 이미 알고 있다.md"
METADATA="$SCRIPT_DIR/metadata.yaml"
CSS="$SCRIPT_DIR/epub-style.css"
COVER="$SCRIPT_DIR/cover.png"  # 표지 이미지

# 출력 파일
OUTPUT_EPUB="$OUTPUT_DIR/그들은_당신이_뭘_볼지_이미_알고_있다.epub"
OUTPUT_DATE=$(date +%Y%m%d)

echo ""
echo "📁 입력 파일: $INPUT_FILE"
echo "📁 출력 파일: $OUTPUT_EPUB"
echo ""

# Pandoc 설치 확인
if ! command -v pandoc &> /dev/null; then
    echo "❌ Pandoc이 설치되어 있지 않습니다."
    echo "   설치: brew install pandoc"
    exit 1
fi

echo "✅ Pandoc 버전: $(pandoc --version | head -n 1)"
echo ""

# ePub 빌드 명령어
PANDOC_CMD="pandoc \"$INPUT_FILE\" \
  -o \"$OUTPUT_EPUB\" \
  --toc \
  --toc-depth=2 \
  --metadata-file=\"$METADATA\" \
  --css=\"$CSS\" \
  --epub-chapter-level=1 \
  --wrap=none"

# 표지 이미지가 있으면 추가
if [ -f "$COVER" ]; then
    PANDOC_CMD="$PANDOC_CMD --epub-cover-image=\"$COVER\""
    echo "✅ 표지 이미지 포함: $COVER"
else
    echo "⚠️  표지 이미지 없음 (cover.jpg를 ebook/ 폴더에 추가하세요)"
fi

echo ""
echo "🔨 ePub 빌드 중..."
echo ""

# 빌드 실행
eval $PANDOC_CMD

# 결과 확인
if [ $? -eq 0 ]; then
    echo ""
    echo "=========================================="
    echo "✅ ePub 빌드 완료!"
    echo "=========================================="
    echo ""
    echo "📄 출력 파일: $OUTPUT_EPUB"
    echo "📊 파일 크기: $(du -h "$OUTPUT_EPUB" | cut -f1)"
    echo ""
    echo "다음 단계:"
    echo "  1. Calibre로 ePub 열어서 미리보기"
    echo "  2. 문제 있으면 수정 후 재빌드"
    echo "  3. 리디북스/교보문고에 업로드"
    echo ""
else
    echo ""
    echo "❌ ePub 빌드 실패"
    echo "   오류 메시지를 확인하세요."
    exit 1
fi
