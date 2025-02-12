use std::path::PathBuf;

use super::print_ast_module;
use kclvm_parser::parse_file;
use pretty_assertions::assert_eq;

const FILE_INPUT_SUFFIX: &str = ".input";
const FILE_OUTPUT_SUFFIX: &str = ".output";
const TEST_CASES: &[&'static str; 16] = &[
    "arguments",
    "empty",
    "if_stmt",
    "import",
    "unary",
    "codelayout",
    "collection_if",
    "comment",
    "index_sign",
    "joined_str",
    "lambda",
    "quant",
    "rule",
    "str",
    "type_alias",
    "unification",
];

fn read_data(data_name: &str) -> (String, String) {
    let mut filename = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    filename.push(&format!("src/test_data/{}{}", data_name, FILE_INPUT_SUFFIX));

    let module = parse_file(filename.to_str().unwrap(), None);

    let mut filename_expect = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
    filename_expect.push(&format!(
        "src/test_data/{}{}",
        data_name, FILE_OUTPUT_SUFFIX
    ));
    (
        print_ast_module(&module.unwrap()),
        std::fs::read_to_string(filename_expect.to_str().unwrap()).unwrap(),
    )
}

#[test]
fn test_ast_printer() {
    for case in TEST_CASES {
        let (data_input, data_output) = read_data(case);

        assert_eq!(data_input, data_output, "Test failed on {}", case);
    }
}
