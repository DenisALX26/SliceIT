"use client";

import Link from "next/link";
import { useSearchParams } from "next/navigation";

type LinkProps = {
  label: string;
  href: string;
  active?: boolean;
};

const NavLink = ({ label, href, active }: LinkProps) => {
  return (
    <li>
      <Link
        className={`uppercase no-underline font-bold ${
          active ? "text-yellow-300 underline" : "text-white hover:underline"
        }`}
        href={href}
      >
        {label}
      </Link>
    </li>
  );
};

export default function Header() {
  const sp = useSearchParams();
  const status = (sp.get("status") ?? "all").toLowerCase();

  return (
    <header className="sticky top-0 w-full z-10 bg-[var(--color-mygray)]">
      <nav>
        <ul className="flex flex-row gap-8 list-none py-4 m-0 items-center justify-center">
          <NavLink label="all" href="/" active={status === "all"} />
          <NavLink label="placed" href="/?status=placed" active={status === "placed"} />
          <NavLink label="preparing" href="/?status=preparing" active={status === "preparing"} />
          <NavLink label="ready" href="/?status=ready" active={status === "ready"} />
        </ul>
      </nav>
    </header>
  );
}