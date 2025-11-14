#!/usr/bin/env python3
"""Generate API reference documentation for the AutoGPT package."""

from __future__ import annotations

import ast
import inspect
from dataclasses import dataclass, field
from datetime import datetime, timezone
from pathlib import Path
from typing import List, Optional

PROJECT_ROOT = Path(__file__).resolve().parents[1]
PACKAGE_ROOT = PROJECT_ROOT / "autogpt"
OUTPUT_PATH = PROJECT_ROOT / "docs" / "api_reference.md"


def ast_to_source(node: ast.AST) -> str:
    """Best-effort conversion of an AST node back to Python source."""
    try:
        return ast.unparse(node)
    except AttributeError:  # pragma: no cover - Python <3.9 fallback
        return ast.dump(node)


def clean_docstring(value: Optional[str]) -> str:
    if not value:
        return "No description available."
    return inspect.cleandoc(value)


def format_annotation(annotation: Optional[ast.AST]) -> str:
    if annotation is None:
        return ""
    return f": {ast_to_source(annotation)}"


def format_default(value: Optional[ast.AST]) -> str:
    if value is None:
        return ""
    return f"={ast_to_source(value)}"


def format_signature(args: ast.arguments) -> str:
    parts: List[str] = []
    pos_args = list(args.posonlyargs) + list(args.args)
    defaults = [None] * (len(pos_args) - len(args.defaults)) + list(args.defaults)

    # Positional-only + standard positional args
    for index, (arg, default) in enumerate(zip(pos_args, defaults)):
        annotation = format_annotation(arg.annotation)
        default_text = format_default(default)
        parts.append(f"{arg.arg}{annotation}{default_text}")
        if index == len(args.posonlyargs) - 1:
            parts.append("/")

    # Vararg
    if args.vararg:
        annotation = format_annotation(args.vararg.annotation)
        parts.append(f"*{args.vararg.arg}{annotation}")
    elif args.kwonlyargs:
        parts.append("*")

    # Keyword-only args
    for arg, default in zip(args.kwonlyargs, args.kw_defaults):
        annotation = format_annotation(arg.annotation)
        default_text = format_default(default)
        parts.append(f"{arg.arg}{annotation}{default_text}")

    # Kwarg
    if args.kwarg:
        annotation = format_annotation(args.kwarg.annotation)
        parts.append(f"**{args.kwarg.arg}{annotation}")

    # Remove trailing "/" if there were no positional-only args
    if parts and parts[-1] == "/":
        parts.pop()

    return f"({', '.join(parts)})"


@dataclass
class FunctionDoc:
    name: str
    signature: str
    docstring: str
    is_async: bool = False


@dataclass
class MethodDoc(FunctionDoc):
    pass


@dataclass
class ClassDoc:
    name: str
    docstring: str
    methods: List[MethodDoc] = field(default_factory=list)


@dataclass
class ModuleDoc:
    name: str
    docstring: str
    functions: List[FunctionDoc] = field(default_factory=list)
    classes: List[ClassDoc] = field(default_factory=list)


def collect_docs() -> List[ModuleDoc]:
    modules: List[ModuleDoc] = []

    for path in sorted(PACKAGE_ROOT.rglob("*.py")):
        module_name = ".".join(path.relative_to(PROJECT_ROOT).with_suffix("").parts)
        source = path.read_text(encoding="utf-8")
        tree = ast.parse(source)
        module_doc = ModuleDoc(
            name=module_name,
            docstring=clean_docstring(ast.get_docstring(tree)),
        )

        for node in tree.body:
            if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                if node.name.startswith("_"):
                    continue
                module_doc.functions.append(
                    FunctionDoc(
                        name=node.name,
                        signature=format_signature(node.args),
                        docstring=clean_docstring(ast.get_docstring(node)),
                        is_async=isinstance(node, ast.AsyncFunctionDef),
                    )
                )
            elif isinstance(node, ast.ClassDef):
                if node.name.startswith("_"):
                    continue
                class_doc = ClassDoc(
                    name=node.name,
                    docstring=clean_docstring(ast.get_docstring(node)),
                )
                for class_node in node.body:
                    if isinstance(class_node, (ast.FunctionDef, ast.AsyncFunctionDef)):
                        if class_node.name.startswith("_"):
                            continue
                        class_doc.methods.append(
                            MethodDoc(
                                name=class_node.name,
                                signature=format_signature(class_node.args),
                                docstring=clean_docstring(ast.get_docstring(class_node)),
                                is_async=isinstance(class_node, ast.AsyncFunctionDef),
                            )
                        )
                module_doc.classes.append(class_doc)

        modules.append(module_doc)

    return modules


def example_block(module: str, name: str, is_async: bool, is_class: bool = False) -> str:
    import_statement = f"from {module} import {name}"
    if is_class:
        body = [
            f"{name[0].lower()}{name[1:]} = {name}(...)",
        ]
    else:
        call = f"{name}(...)"
        if is_async:
            call = f"await {call}"
        body = [call]

    snippet = "\n".join(body)
    return f"```python\n{import_statement}\n\n{snippet}\n```"


def method_example_block(class_name: str, method: MethodDoc) -> str:
    instance_name = class_name[0].lower() + class_name[1:]
    call = f"{instance_name}.{method.name}(...)"
    if method.is_async:
        call = f"await {call}"
    return (
        "```python\n"
        f"{instance_name} = {class_name}(...)\n"
        f"{call}\n"
        "```"
    )


def build_document(modules: List[ModuleDoc]) -> str:
    timestamp = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M UTC")
    lines: List[str] = [
        "# AutoGPT API Reference",
        "",
        f"_Generated automatically on {timestamp}_",
        "",
    ]

    for module in modules:
        lines.append(f"## Module: `{module.name}`")
        lines.append("")
        lines.append(module.docstring)
        lines.append("")

        if module.functions:
            lines.append("### Functions")
            lines.append("")
            for function in module.functions:
                async_label = " (async)" if function.is_async else ""
                lines.append(f"#### `{function.name}{function.signature}`{async_label}")
                lines.append("")
                lines.append(function.docstring)
                lines.append("")
                lines.append("Example:")
                lines.append("")
                lines.append(
                    example_block(module.name, function.name, function.is_async)
                )
                lines.append("")

        if module.classes:
            lines.append("### Classes")
            lines.append("")
            for cls in module.classes:
                lines.append(f"#### `{cls.name}`")
                lines.append("")
                lines.append(cls.docstring)
                lines.append("")
                lines.append("Example:")
                lines.append("")
                lines.append(example_block(module.name, cls.name, False, is_class=True))
                lines.append("")

                if cls.methods:
                    lines.append("##### Methods")
                    lines.append("")
                    for method in cls.methods:
                        async_label = " (async)" if method.is_async else ""
                        lines.append(
                            f"- `{method.name}{method.signature}`{async_label}: {method.docstring}"
                        )
                        lines.append("")
                        lines.append("  Example:")
                        lines.append("")
                        lines.append(method_example_block(cls.name, method))
                        lines.append("")

        lines.append("---")
        lines.append("")

    return "\n".join(lines).strip() + "\n"


def main() -> None:
    if not PACKAGE_ROOT.exists():
        raise SystemExit(f"Package path not found: {PACKAGE_ROOT}")

    modules = collect_docs()
    document = build_document(modules)
    OUTPUT_PATH.write_text(document, encoding="utf-8")
    print(f"Wrote API reference to {OUTPUT_PATH}")


if __name__ == "__main__":
    main()
