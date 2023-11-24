# for file in posts/*.typ; do
#   filename=$(basename "$file" .typ)
#   pandoc -o "dist/$filename.html" "$file" -s --mathml
# done
# above is a piece of shell code that converts all *.typ files under posts folder to html files. All typ files are named like "20231123-test.typ", so before the hyphen is the date, after hyphen is the name(of course we should ignore the extension name). I would like you to collect all these information of those files under posts, and then:
# 1. ranked them by date, with latest date at the first.
# 2. for each file, you need to generate a HTML string like this "<a class="blog-name" target="_blank" href="dist\20231123-test.html">blog_title</a>
#             <span class="blog-date">2023-01-01</span>", as you can see, you need to use the information collected at last step to replace some of the fields in the string.
# 3. concatenate all these strings, then replace "[TO_BE_REPLACED_BY_LI_ITEMS]" in index.html with the concatenated string

# below is the answer from chatgpt
html_strings=""
rm dist/*
for file in $(ls -1 posts/*.typ | sort -r); do
    filename=$(basename "$file" .typ)
    pandoc -o "dist/$filename.html" "$file" -s --mathml --css=style.css --template "template/my_page_template.html"
    date_part=$(echo "$filename" | cut -d'-' -f1)
    title_part=$(echo "$filename" | cut -d'-' -f2-)
    formatted_date=$(date -d "$date_part" "+%Y-%m-%d")

    html_strings+="<li>
                <a class=\"blog-name\" target=\"_blank\" href=\"dist/$filename.html\">$title_part</a>
                <span class=\"blog-date\">$formatted_date</span>
            </li>"
done
# Create a temporary file to store the HTML strings
echo "$html_strings" >temp_html_file

# Replace placeholder in index.html with the content from the file
cp index_template.html index.html
sed -i -e '/TO_BE_REPLACED_BY_LI_ITEM/ {' -e 'r temp_html_file' -e 'd;}' index.html

# Remove the temporary file
rm temp_html_file
cp style.css dist/style.css
